-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 11, 2025 at 05:16 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eduquiz_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`) VALUES
(1, 'Technologyhhh', 'Quizzes about programming, computers, and digital technologyhhddd'),
(2, 'Science', 'Quizzes covering physics, chemistry, biology and other sciences'),
(3, 'History', 'Quizzes about historical events, people, and periods'),
(4, 'Literature', 'Quizzes about books, authors, and literary movements'),
(5, 'Mathematics', 'Quizzes about algebra, geometry, calculus, and other math topics');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE `questions` (
  `id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `option_a` text NOT NULL,
  `option_b` text NOT NULL,
  `option_c` text NOT NULL,
  `option_d` text NOT NULL,
  `correct_answer` char(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `quiz_id`, `question_text`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_answer`) VALUES
(1, 1, 'Which of the following is a valid Java variable name?', '_myVariable', '5variable', 'my-variable', 'class', 'A'),
(2, 1, 'What is the output of: System.out.println(5 + 7 + \"Java\");', '12Java', '5 + 7 + Java', 'Java57', 'Error', 'A'),
(3, 1, 'Which data type is used to create a variable that stores text in Java?', 'int', 'text', 'string', 'String', 'D'),
(4, 1, 'What does JVM stand for?', 'Java Variable Method', 'Java Virtual Machine', 'Java Volatile Memory', 'Java Visual Module', 'B'),
(5, 1, 'Which keyword is used to define a constant in Java?', 'const', 'var', 'final', 'static', 'C'),
(6, 1, 'Which of the following is a valid Java variable name?', '_myVariable', '5variable', 'my-variable', 'class', 'A'),
(7, 1, 'What is the output of: System.out.println(5 + 7 + \"Java\");', '12Java', '5 + 7 + Java', 'Java57', 'Error', 'A'),
(8, 1, 'Which data type is used to create a variable that stores text in Java?', 'int', 'text', 'string', 'String', 'D'),
(9, 1, 'What does JVM stand for?', 'Java Variable Method', 'Java Virtual Machine', 'Java Volatile Memory', 'Java Visual Module', 'B'),
(10, 1, 'Which keyword is used to define a constant in Java?', 'const', 'var', 'final', 'static', 'C'),
(11, 2, 'What is a closure in JavaScript?', 'A function that has access to its own scope, the outer function\'s scope, and global scope', 'A function defined inside another function', 'A way to close multiple browser windows', 'A method to secure JavaScript code', 'A'),
(12, 2, 'What does the \"Promise.all()\" method do?', 'Returns a promise that fulfills when any of the input promises fulfill', 'Returns a promise that fulfills when all input promises fulfill', 'Returns multiple promises in sequence', 'Creates a chain of promises', 'B'),
(13, 2, 'What is the event loop in JavaScript?', 'A design pattern used for event handling', 'The way JavaScript handles asynchronous code execution', 'A loop that continuously checks for UI events', 'A special type of for-loop', 'B'),
(14, 2, 'Which statement about the \"this\" keyword in JavaScript is true?', 'It always refers to the global object', 'Its value is always determined by how a function is called', 'It always refers to the object that defined the method', 'It can be set only once during program execution', 'B'),
(15, 2, 'What is the purpose of the \"async/await\" feature in JavaScript?', 'To make all JavaScript operations synchronous', 'To simplify working with promises and asynchronous code', 'To improve performance of JavaScript applications', 'To allow JavaScript to perform multiple tasks simultaneously', 'B'),
(16, 3, 'Which HTML tag is used to create a hyperlink?', 'link', 'a', 'href', 'hyperlink', 'B'),
(17, 3, 'Which CSS property is used to change the text color of an element?', 'font-color', 'text-color', 'color', 'text-style', 'C'),
(18, 3, 'Which of the following is NOT a JavaScript data type?', 'String', 'Boolean', 'Float', 'Symbol', 'C'),
(19, 3, 'What does CSS stand for?', 'Creative Style Sheets', 'Computer Style Sheets', 'Cascading Style Sheets', 'Colorful Style Sheets', 'C'),
(20, 3, 'Which HTML5 element is used to play video files?', 'media', 'video', 'movie', 'play', 'B'),
(21, 4, 'Which SQL keyword is used to retrieve data from a database?', 'OPEN', 'EXTRACT', 'SELECT', 'CAPTURE', 'C'),
(22, 4, 'What does the HAVING clause do in SQL?', 'Filters rows before they are grouped', 'Filters groups after they are formed', 'Sorts the final result set', 'Joins tables together', 'B'),
(23, 4, 'Which type of JOIN returns rows that have matching values in both tables?', 'OUTER JOIN', 'INNER JOIN', 'FULL JOIN', 'RIGHT JOIN', 'B'),
(24, 4, 'What is a subquery in SQL?', 'A query within another query', 'A query that runs after the main query', 'A query that executes faster than normal queries', 'A query that only accesses system tables', 'A'),
(25, 4, 'Which SQL function is used to find the number of rows in a result set?', 'TOTAL()', 'SUM()', 'COUNT()', 'NUM()', 'C'),
(26, 5, 'What is Newton\'s First Law of Motion?', 'Force equals mass times acceleration', 'Every action has an equal and opposite reaction', 'Energy cannot be created or destroyed', 'An object in motion stays in motion unless acted upon by an external force', 'D'),
(27, 5, 'What is the SI unit of force?', 'Watt', 'Joule', 'Newton', 'Pascal', 'C'),
(28, 5, 'Which of these is NOT a state of matter?', 'Solid', 'Liquid', 'Gas', 'Energy', 'D'),
(29, 5, 'What does E=mc² represent?', 'Theory of Relativity', 'Newton\'s Second Law', 'Law of Conservation of Energy', 'Ohm\'s Law', 'A'),
(30, 5, 'What type of wave is sound?', 'Transverse wave', 'Electromagnetic wave', 'Longitudinal wave', 'Surface wave', 'C'),
(31, 6, 'What is the chemical symbol for gold?', 'Gd', 'Au', 'Ag', 'Go', 'B'),
(32, 6, 'Which of the following is NOT a noble gas?', 'Helium', 'Neon', 'Nitrogen', 'Argon', 'C'),
(33, 6, 'What is pH a measure of?', 'Hydrogen ion concentration', 'Oxygen level', 'Pressure and height', 'Potential hazard', 'A'),
(34, 6, 'Which subatomic particle has a positive charge?', 'Electron', 'Neutron', 'Proton', 'Photon', 'C'),
(35, 6, 'What type of reaction occurs when an acid and base combine?', 'Combustion', 'Neutralization', 'Oxidation', 'Reduction', 'B'),
(36, 7, 'Which organelle is known as the powerhouse of the cell?', 'Nucleus', 'Ribosome', 'Mitochondria', 'Golgi apparatus', 'C'),
(37, 7, 'What is the process by which cells break down glucose to produce energy?', 'Photosynthesis', 'Cellular respiration', 'Fermentation', 'Osmosis', 'B'),
(38, 7, 'Which of the following is NOT a nucleotide found in DNA?', 'Adenine', 'Thymine', 'Uracil', 'Guanine', 'C'),
(39, 7, 'What is the primary function of the lysosome?', 'Protein synthesis', 'Cellular digestion', 'Energy production', 'Lipid synthesis', 'B'),
(40, 7, 'Which of the following is a correct statement about meiosis?', 'It produces 2 genetically identical daughter cells', 'It occurs only in reproductive cells', 'It involves one cell division', 'It produces cells with the same number of chromosomes as the parent cell', 'B'),
(41, 8, 'Which ancient civilization built the pyramids at Giza?', 'Mesopotamians', 'Egyptians', 'Romans', 'Greeks', 'B'),
(42, 8, 'Which of these was NOT an ancient Mesopotamian civilization?', 'Sumerian', 'Babylonian', 'Mayan', 'Akkadian', 'C'),
(43, 8, 'The Great Wall of China was primarily built to defend against which people?', 'Mongols', 'Japanese', 'Russians', 'Indians', 'A'),
(44, 8, 'Which ancient civilization used hieroglyphics as their writing system?', 'Romans', 'Chinese', 'Egyptians', 'Aztecs', 'C'),
(45, 8, 'Which ancient civilization developed democracy?', 'Romans', 'Persians', 'Greeks', 'Egyptians', 'C'),
(46, 9, 'When did World War II begin?', '1935', '1939', '1941', '1945', 'B'),
(47, 9, 'Which country was NOT part of the Axis powers?', 'Germany', 'Italy', 'Japan', 'Soviet Union', 'D'),
(48, 9, 'What was the code name for the Allied invasion of Normandy in 1944?', 'Operation Market Garden', 'Operation Overlord', 'Operation Torch', 'Operation Barbarossa', 'B'),
(49, 9, 'Who was the Prime Minister of Great Britain for most of World War II?', 'Neville Chamberlain', 'Winston Churchill', 'Clement Attlee', 'Stanley Baldwin', 'B'),
(50, 9, 'What was the name of the American program to develop the atomic bomb?', 'The Einstein Project', 'The Manhattan Project', 'Operation Downfall', 'Project Atomic', 'B'),
(51, 10, 'What event marked the beginning of the Middle Ages?', 'The fall of Rome', 'The Black Death', 'The Crusades', 'The Norman Conquest', 'A'),
(52, 10, 'Who was the first Holy Roman Emperor?', 'Frederick Barbarossa', 'Otto I', 'Charlemagne', 'Constantine', 'C'),
(53, 10, 'What was the Magna Carta?', 'A religious text', 'A document limiting the power of the king', 'A medieval map', 'A type of medieval fortress', 'B'),
(54, 10, 'What medieval disease killed approximately one-third of Europe\'s population?', 'Smallpox', 'Tuberculosis', 'The Black Death', 'Cholera', 'C'),
(55, 10, 'What was feudalism?', 'A political system based on landlords and serfs', 'A type of religious practice', 'A method of farming', 'A medieval entertainment', 'A'),
(56, 11, 'Who wrote \"Pride and Prejudice\"?', 'Charles Dickens', 'Jane Austen', 'Emily Brontë', 'Virginia Woolf', 'B'),
(57, 11, 'Which of these is NOT written by Charles Dickens?', 'Great Expectations', 'Oliver Twist', 'Wuthering Heights', 'A Tale of Two Cities', 'C'),
(58, 11, 'Who wrote \"War and Peace\"?', 'Fyodor Dostoevsky', 'Anton Chekhov', 'Leo Tolstoy', 'Ivan Turgenev', 'C'),
(59, 11, 'What is the name of the main character in \"Moby Dick\"?', 'Ishmael', 'Ahab', 'Queequeg', 'Starbuck', 'A'),
(60, 11, 'Which Jane Austen novel features the character Emma Woodhouse?', 'Sense and Sensibility', 'Pride and Prejudice', 'Emma', 'Persuasion', 'C'),
(61, 12, '\"To be, or not to be\" is a famous line from which Shakespeare play?', 'Romeo and Juliet', 'Macbeth', 'Hamlet', 'King Lear', 'C'),
(62, 12, 'Who is the main antagonist in Shakespeare\'s \"Othello\"?', 'Cassio', 'Iago', 'Roderigo', 'Brabantio', 'B'),
(63, 12, 'How many plays is Shakespeare generally considered to have written?', '25', '37', '50', '100', 'B'),
(64, 12, 'Which of these is NOT a Shakespearean comedy?', 'A Midsummer Night\'s Dream', 'Twelfth Night', 'Macbeth', 'Much Ado About Nothing', 'C'),
(65, 12, 'In which city are Romeo and Juliet from?', 'Venice', 'Verona', 'Rome', 'Florence', 'B'),
(66, 13, 'Who wrote the Harry Potter series?', 'J.R.R. Tolkien', 'J.K. Rowling', 'Stephen King', 'George R.R. Martin', 'B'),
(67, 13, 'Which of these books is NOT written by George Orwell?', '1984', 'Animal Farm', 'Brave New World', 'Down and Out in Paris and London', 'C'),
(68, 13, 'What is the first book in \"The Hunger Games\" trilogy?', 'Catching Fire', 'The Hunger Games', 'Mockingjay', 'The Tribute', 'B'),
(69, 13, 'Who wrote \"The Da Vinci Code\"?', 'Dan Brown', 'John Grisham', 'Michael Crichton', 'Tom Clancy', 'A'),
(70, 13, 'Which of these is a novel by Margaret Atwood?', 'Beloved', 'The Handmaid\'s Tale', 'The Color Purple', 'The Bell Jar', 'B'),
(71, 14, 'What is the value of x in the equation 2x + 5 = 15?', '5', '10', '7.5', '5.5', 'A'),
(72, 14, 'Which of the following is a quadratic equation?', 'y = mx + b', 'y = x²', 'y = 1/x', 'y = x³', 'B'),
(73, 14, 'What is the result of (x + 3)(x - 2)?', 'x² + x - 6', 'x² + 5x - 6', 'x² - 5x - 6', 'x² + x + 6', 'A'),
(74, 14, 'If 3x - 5 = 16, what is the value of x?', '7', '3.67', '6', '7.33', 'A'),
(75, 14, 'What does the slope of a line represent?', 'The y-intercept', 'The rise over run ratio', 'The x-intercept', 'The distance of the line', 'B'),
(76, 15, 'What is the formula for the area of a circle?', 'A = πr', 'A = 2πr', 'A = πr²', 'A = πd', 'C'),
(77, 15, 'What is the Pythagorean theorem?', 'a² + b² = c²', 'a + b + c = 180°', 'a² - b² = c²', 'a/sin A = b/sin B = c/sin C', 'A'),
(78, 15, 'How many sides does a heptagon have?', '5', '6', '7', '8', 'C'),
(79, 15, 'What is the sum of interior angles of a triangle?', '90°', '180°', '270°', '360°', 'B'),
(80, 15, 'Which of the following is NOT a type of triangle based on its angles?', 'Acute', 'Obtuse', 'Right', 'Parallel', 'D'),
(81, 16, 'What is the derivative of sin(x)?', 'cos(x)', '-sin(x)', 'tan(x)', '-cos(x)', 'A'),
(82, 16, 'What does the second derivative of a function represent?', 'Rate of change', 'Rate of change of the rate of change', 'Area under the curve', 'Volume', 'B'),
(83, 16, 'What is an improper integral?', 'An integral that cannot be evaluated', 'An integral with infinite limits or integrand that becomes infinite', 'An integral with negative values', 'An integral that doesn\'t use the Riemann sum', 'B'),
(84, 16, 'What does the chain rule allow us to find?', 'The derivative of a constant', 'The derivative of a composite function', 'The integral of a function', 'The limit of a function', 'B'),
(85, 16, 'What is a partial derivative?', 'A derivative that only partially solves the problem', 'A derivative of a function of multiple variables with respect to one variable', 'Half of the regular derivative', 'A derivative that can only be expressed as a fraction', 'B'),
(149, 25, 'In the 1995 film \"Balto\", who are Steele\'s accomplices?', 'Jenna, Sylvie, and Dixie', 'Nuk, Yak, and Sumac', 'Dusty, Kirby, and Ralph', 'Kaltag, Nikki, and Star', 'D'),
(150, 25, 'When does \"Rogue One: A Star Wars Story\" take place chronologically in the series?', 'Before Episode 1', 'After Episode 6', 'Between Episode 3 and 4', 'Between Episode 4 and 5', 'C'),
(151, 25, 'In the 1994 movie \"Speed\", what is the minimum speed the bus must go to prevent to bomb from exploding?', '40 mph', '70 mph', '50 mph', '60 mph', 'C'),
(152, 25, 'In which African country was the 2006 film \'Blood Diamond\' mostly set in?', 'Burkina Faso', 'Central African Republic', 'Sierra Leone', 'Liberia', 'C'),
(153, 25, 'What name did Tom Hanks give to his volleyball companion in the film `Cast Away`?', 'Wilson', 'Friday', 'Jones', 'Billy', 'A'),
(154, 25, 'What is the orange and white bot\'s name in \"Star Wars: The Force Awakens\"?', 'AA-A', 'R2-D2', 'BB-3', 'BB-8', 'D'),
(155, 25, 'Who in Pulp Fiction says \"No, they got the metric system there, they wouldn\'t know what the f*** a Quarter Pounder is.\"', 'Jules Winnfield', 'Butch Coolidge', 'Jimmie Dimmick', 'Vincent Vega', 'D'),
(156, 25, 'In the movie \"V for Vendetta,\" what is the date that masked vigilante \"V\" urges people to remember?', 'November 5th', 'November 4th', 'November 6th', 'September 5th', 'A'),
(157, 25, 'Who starred in the film 1973 movie \"Enter The Dragon\"?', 'Jackie Chan', 'Bruce Lee', 'Jet Li', ' Yun-Fat Chow', 'B'),
(158, 25, 'The Queen song `A Kind Of Magic` is featured in which 1986 film?', 'Howard the Duck', 'Highlander', 'Labyrinth', 'Flash Gordon', 'B');

-- --------------------------------------------------------

--
-- Table structure for table `quizzes`
--

CREATE TABLE `quizzes` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `difficulty` varchar(20) DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `max_score` int(11) NOT NULL DEFAULT 0,
  `is_temporary` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizzes`
--

INSERT INTO `quizzes` (`id`, `title`, `description`, `category_id`, `difficulty`, `time_limit`, `max_score`, `is_temporary`) VALUES
(1, 'Java Basics', 'Test your knowledge of Java fundamentals including syntax, variables, and control structures.', 1, 'Easy', 10, 0, 0),
(2, 'Advanced JavaScript', 'Challenge yourself with complex JavaScript concepts like closures, promises, and the event loop.', 1, 'Hard', 15, 0, 0),
(3, 'Web Development Essentials', 'Cover the basics of HTML, CSS, and JavaScript for web development.', 1, 'Medium', 12, 0, 0),
(4, 'SQL Mastery', 'Test your database query skills with complex SQL challenges.', 1, 'Hard', 20, 0, 0),
(5, 'Basic Physics', 'Test your understanding of fundamental physics concepts and laws.', 2, 'Easy', 8, 0, 0),
(6, 'Chemistry 101', 'A quiz covering basic chemical reactions, elements, and the periodic table.', 2, 'Medium', 10, 0, 0),
(7, 'Advanced Biology', 'Deep dive into cellular structures, genetics, and biological systems.', 2, 'Hard', 15, 0, 0),
(8, 'Ancient Civilizations', 'Explore the wonders and achievements of ancient world civilizations.', 3, 'Medium', 12, 0, 0),
(9, 'World War II', 'Test your knowledge about major events, figures, and impacts of World War II.', 3, 'Medium', 15, 0, 0),
(10, 'Medieval History', 'Journey through the Middle Ages and test your medieval history knowledge.', 3, 'Easy', 10, 0, 0),
(11, 'Classic Literature', 'Test your knowledge of famous classic novels and their authors.', 4, 'Medium', 12, 0, 0),
(12, 'Shakespeare Works', 'A challenging quiz about Shakespeare\'s plays, sonnets, and literary devices.', 4, 'Hard', 15, 0, 0),
(13, 'Modern Fiction', 'Explore contemporary novels, authors, and literary movements.', 4, 'Easy', 10, 0, 0),
(14, 'ALgebra', 'Test your ', 1, 'medium', 16, 0, 0),
(15, 'Geometry Challenges', 'Put your geometry knowledge to the test with shapes, theorems, and proofs.', 5, 'Medium', 12, 0, 0),
(16, 'Advanced Calculus', 'Challenge yourself with integral calculus, differential equations, and applications.', 5, 'Hard', 20, 0, 0),
(25, 'HHHH', 'HHHH', 4, 'medium', 30, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `quiz_id` int(11) DEFAULT NULL,
  `score` float DEFAULT NULL,
  `completion_time` int(11) DEFAULT NULL,
  `date_taken` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`id`, `user_id`, `quiz_id`, `score`, `completion_time`, `date_taken`) VALUES
(45, 24, 16, 20, 14, '2025-05-30 18:46:38'),
(47, 28, 8, 20, 10, '2025-05-30 20:49:36');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'user',
  `profile_image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `active` tinyint(1) DEFAULT 1,
  `wallet_address` varchar(42) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `profile_image`, `created_at`, `active`, `wallet_address`) VALUES
(24, 'Admin', 'admin@gmail.com', '$2a$10$bnbJ7vWHPHCT8CYSlyiriOzAca9SkJ46MQvuo4MWgQa8eyoVpoOHq', 'admin', NULL, '2025-05-30 18:38:15', 1, NULL),
(28, 'TEST', 'test@gmail.com', '$2a$10$soWnrUcUt730q.bkz1TlxOJHG4do9lZHdxX/nZbRyllm0HEVwe5hS', 'user', NULL, '2025-05-30 20:48:45', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questions`
--
ALTER TABLE `questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_wallet_address` (`wallet_address`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `questions`
--
ALTER TABLE `questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=159;

--
-- AUTO_INCREMENT for table `quizzes`
--
ALTER TABLE `quizzes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quizzes`
--
ALTER TABLE `quizzes`
  ADD CONSTRAINT `quizzes_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `scores_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
