-- # QUERY CON SELECT # --

-- 1. Selezionare tutti gli studenti nati nel 1990 (160)

SELECT * FROM `students` WHERE YEAR(`date_of_birth`) = 1990;

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)

SELECT * FROM `courses` WHERE `cfu` > 10;

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni

SELECT * FROM `students` WHERE YEAR(`date_of_birth`) < 1990;

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di
-- laurea (286)

SELECT * FROM `courses` WHERE `period` = 'I semestre' AND year = 1;

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del
-- 20/06/2020 (21)

SELECT * FROM `exams` WHERE `date` = '2020-06-20' AND `hour` >= '14:00:00';

-- 6. Selezionare tutti i corsi di laurea magistrale (38)

SELECT * FROM `degrees` WHERE `level` = 'magistrale';

-- 7. Da quanti dipartimenti è composta l'università? (12)

SELECT COUNT(*) FROM `departments`;

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)

SELECT * FROM `teachers` WHERE `phone` IS NULL;

--------------------------------------------

-- # QUERY CON GROUP BY # --

-- 1. Contare quanti iscritti ci sono stati ogni anno

SELECT YEAR(`enrolment_date`) AS `anno_di_iscrizione`, COUNT(*) AS `totale_studenti` FROM `students` GROUP BY `anno_di_iscrizione`;

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio

SELECT `office_address` AS `indirizzo_ufficio`, COUNT(*) AS `numero_insegnanti` FROM `teachers` GROUP BY `indirizzo_ufficio`;

-- 3. Calcolare la media dei voti di ogni appello d'esame

SELECT `exam_id` AS `id_esame`, AVG(`vote`) AS `media_voti` FROM `exam_student` GROUP BY `id_esame`;

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento

SELECT `department_id` AS `id_dipartimento`, COUNT(*) AS `numero_corsi` FROM `degrees` GROUP BY `id_dipartimento`;

--------------------------------------------

-- # QUERY CON JOIN # --

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia

SELECT S.`id`, S.`name` AS `nome`, S.`surname` AS `cognome`, D.`name` AS `corso_di_laurea`
FROM `students`AS S
JOIN `degrees` AS D ON D.`id` = S.`degree_id`
WHERE D.`name` = 'Corso di laurea in Economia';

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze

SELECT DEG.`name` AS `corso_di_laurea`, DEP.`name` AS `dipartimento`
FROM `degrees` AS DEG
JOIN `departments` AS DEP ON DEP.`id` = DEG.`department_id`
WHERE DEP.`name` = 'Dipartimento di Neuroscienze';

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

SELECT C.`id` AS `id_corso`, C.`name` AS `nome_corso` ,T.`id` AS `id_professore`, T.`name` AS `nome`, T.`surname` AS `cognome`
FROM `courses` AS C
JOIN `course_teacher` AS CT ON C.`id` = CT.`course_id`
JOIN `teachers` AS T ON T.`id` = CT.`teacher_id`
WHERE T.`name` = 'Fulvio' AND T.`surname` = 'Amato';

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il
-- relativo dipartimento, in ordine alfabetico per cognome e nome

SELECT S.*, DEG.`name` AS `corso_di_laurea`, DEP.name AS `dipartimento`
FROM `students` as S
JOIN `degrees` AS DEG ON DEG.`id` = S.`degree_id`
JOIN `departments` AS DEP ON DEP.`id` = DEG.`department_id`
ORDER BY S.`surname`, S.`name`;

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti

SELECT D.`name` AS `corso_di_laurea`, C.`name` AS `corso`, T.`name` AS `nome_insegnante`, T.`surname` AS `cognome_insegnate`
FROM `degrees` AS D
JOIN `courses` AS C ON C.`degree_id` = D.`id`
JOIN `course_teacher` AS CT ON CT.`course_id` = C.`id` 
JOIN `teachers` AS T ON CT.`teacher_id` = T.`id`
ORDER BY D.`name`, C.`name`, T.`name`, T.`surname`;

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)

SELECT DISTINCT T.`name` AS `nome_insegnante`, D.`name` AS `dipartimento`
FROM `teachers` AS T
JOIN `course_teacher` AS CT ON T.`id` = CT.`teacher_id`
JOIN `courses` AS C ON C.`id` = CT.`course_id`
JOIN `degrees` AS DEG ON DEG.`id` = C.`degree_id`
JOIN `departments` AS D ON D.`id` = DEG.`department_id`
WHERE D.`name` = 'Dipartimento di Matematica';

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per 
-- superare ciascuno dei suoi esami
