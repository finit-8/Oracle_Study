-- 구조세트
SELECT FROM 
DELETE FROM 

INSERT INTO VALUES 
UPDATE SET
	

-- UPDATE DELETE
SELECT * FROM TBL_PRODUCT;

UPDATE TBL_PRODUCT
SET PRODUCT_STOCK = 100 
WHERE ID = 2;
SELECT * FROM TBL_PRODUCT;

DELETE FROM TBL_PRODUCT
WHERE ID = 5;
SELECT * FROM TBL_PRODUCT;


-- 정렬(정렬은 마지막 순서)
-- ORDER BY
-- ORDER BY 컬럼명 ASC --> 오름차순 (DEFAULT)
-- ORDER BY 컬럼명 DESC --> 내림차순
SELECT *
FROM TBL_PRODUCT
WHERE PRODUCT_NAME = '배승원의 그램'
ORDER BY ID DESC;


-- ==================================================
-- 서브쿼리(SUB QUERY) : 나중에 조건식이 많아지면 헷갈리기 때문에 서브쿼리로 조건을 주면서 조건식의 양을 줄여줄 수 있다.

-- WHERE에 붙으면 서브쿼리
-- SELECT에 붙으면 스칼라
-- FROM에 붙으면 인라인뷰


-- 평균가격보다 가격이 낮은 상품의 ID를 조회
SELECT ID 
FROM TBL_PRODUCT
WHERE PRODUCT_STOCK < (
	SELECT AVG(PRODUCT_PRICE) 
	FROM TBL_PRODUCT
);

-- 평균재고보다 많은 상품을 조회
SELECT * 
FROM TBL_PRODUCT 
WHERE PRODUCT_STOCK > (
	SELECT AVG(PRODUCT_STOCK)
	FROM TBL_PRODUCT
)
ORDER BY ID DESC;


-- FROM절에 사용 : IN LINE VIEW
-- 재고가 20개인 상품의 평균 가격
SELECT AVG(PRODUCT_PRICE)
FROM (
	SELECT *
	FROM TBL_PRODUCT
	WHERE PRODUCT_STOCK = 20
);

-- SELECT절에 사용: SCALAR
-- 여러 결과를 한 번에 조회하고 싶을 때 사용
-- 그룹바이절에 묶여있는 결과값(집계함수 결과값)과 단일값을 한 번에 조회하고 싶을 때 사용
-- 근데 이름이 헷갈리기 때문에 알리아스 이름 부여한다.

-- =======================================================================
-- 서브쿼리 실습
-- 사용자가 게시판에 글을 작성하고 댓글을 다는 경우.
-- 테이블: 사용자 게시판 댓글
-- 사용자 1(PK) : 댓글 다(FK) ==> 댓글테이블이 사용자테이블 참조
-- 게시글 1(PK) : 댓글 다(FK) ==> 댓글테이블이 게시글테이블 참조
CREATE SEQUENCE SEQ_USER;
CREATE TABLE TBL_USER(
	ID NUMBER CONSTRAINT PK_USER PRIMARY KEY,
	USER_EMAIL VARCHAR2(255) NOT NULL UNIQUE,
	USER_PASSWORD VARCHAR2(255) NOT NULL,
	USER_ADDRESS VARCHAR2(255),
	USER_BIRTH DATE
);
INSERT INTO TBL_USER 
VALUES(SEQ_USER.NEXTVAL, 'HGD1234@GMAIL.COM', '1234', '서울시 강남구', '2002-07-15');
INSERT INTO TBL_USER 
VALUES(SEQ_USER.NEXTVAL, 'JBG1234@GMAIL.COM', '1234', '경기도 성남시', '1995-01-23');
INSERT INTO TBL_USER 
VALUES(SEQ_USER.NEXTVAL, 'LSS1234@GMAIL.COM', '1234', '수원시 팔달구', '1998-03-01');
INSERT INTO TBL_USER 
VALUES(SEQ_USER.NEXTVAL, 'KYH1234@NAVER.COM', '1234', '서울시 마포구', '2002-07-15');
INSERT INTO TBL_USER 
VALUES(SEQ_USER.NEXTVAL, 'KCS1234@NAVER.COM', '1234', '서울시 동작구', '1992-03-30');
INSERT INTO TBL_USER 
VALUES(SEQ_USER.NEXTVAL, 'CJS1234@GMAIL.COM', '1234', '화성시 동탄', '2002-02-18');

SELECT * FROM TBL_USER; -- 6개

CREATE SEQUENCE SEQ_POST;
CREATE TABLE TBL_POST(
	ID NUMBER CONSTRAINT PK_POST PRIMARY KEY,
	POST_TITLE VARCHAR2(255) NOT NULL,
	POST_CONTENT VARCHAR2(255) NOT NULL,
	-- 댓글
	USER_ID NUMBER,
	CONSTRAINT FK_POST_USER FOREIGN KEY(USER_ID)
	REFERENCES TBL_USER(ID)
);
INSERT INTO TBL_POST
VALUES(SEQ_POST.NEXTVAL, '이승찬 맥북 갔다버려!', '컴퓨터는 역시 그램', 1);
INSERT INTO TBL_POST
VALUES(SEQ_POST.NEXTVAL, '배승원 카드놀이 좀 그만해!', '알트탭 천재 배승원', 2);
INSERT INTO TBL_POST
VALUES(SEQ_POST.NEXTVAL, '마우스 뭐가 좋아요?', '마우스 고장났는데 새로 사고싶어요', 3);
INSERT INTO TBL_POST
VALUES(SEQ_POST.NEXTVAL, '100만원으로 살 수 있는 컴퓨터 추천 좀', '쓰던 컴퓨터가 고장났어요', 5);
INSERT INTO TBL_POST
VALUES(SEQ_POST.NEXTVAL, '아직 다 못썼어요', '제가 안썼어요 저는 몰라요', 2);
INSERT INTO TBL_POST
VALUES(SEQ_POST.NEXTVAL, '레전드 네버 다이', '나는야 페이커', 1);

SELECT * FROM TBL_POST; -- 6개

-- 댓글 (중간테이블)
CREATE SEQUENCE SEQ_REPLY;
CREATE TABLE TBL_REPLY(
	ID NUMBER CONSTRAINT PK_REPLY PRIMARY KEY,
	REPLY_CONTENT VARCHAR2(255),
	USER_ID NUMBER,
	POST_ID NUMBER,
	CONSTRAINT FK_REPLY_USER FOREIGN KEY(USER_ID)
	REFERENCES TBL_USER(ID),
	CONSTRAINT FK_REPLY_POST FOREIGN KEY(POST_ID)
	REFERENCES TBL_POST(ID)
);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '한민이형 감히', 6, 1);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '한민이형 넌 별것도 아니야', 6, 3);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '한민이형은 나의 도구', 6, 4);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '한민이형 밥 좀 사줘요', 6, 5);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '그램보단 콩순이 컴퓨터가 낫다', 2, 1);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '갤럭시북 세일할 때 사세요', 1, 4);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '와 진짜 저건 저항 받겠다. 인성 ㄷㄷ', 3, 2);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '맥북 에어 사세요', 4, 4);
INSERT INTO TBL_REPLY
VALUES(SEQ_REPLY.NEXTVAL, '한민이형 질문 좀 해도 될까요?', 6, 1);

SELECT * FROM TBL_REPLY; -- 9개

-- 6번 유저가 댓글을 단 게시글의 목록 조회 과정
-- 
SELECT *
FROM TBL_REPLY
WHERE USER_ID = 6;

--
SELECT USER_ID 
FROM TBL_REPLY
WHERE USER_ID = 6;

-- 6번 유저가 댓글을 단 게시글의 목록
SELECT *
FROM TBL_POST
WHERE ID IN (
	SELECT USER_ID 
	FROM TBL_REPLY
	WHERE USER_ID = 6
);



SELECT * FROM TBL_USER;
SELECT * FROM TBL_POST;
SELECT * FROM TBL_REPLY;
-- 댓글을 단 사용자의 ID와 ADDRESS 조회
SELECT DISTINCT USER_ID		-- 중복제거
FROM TBL_REPLY 

SELECT ID, USER_ADDRESS
FROM TBL_USER
WHERE ID IN (				-- 자동중복제거
	SELECT USER_ID
	FROM TBL_REPLY 
);




-- 댓글을 가장 많이 단 사용자 조회
SELECT MAX(USER_ID)
FROM TBL_REPLY;

SELECT *
FROM TBL_USER
WHERE ID IN (
	SELECT MAX(USER_ID)
	FROM TBL_REPLY
);

	-- 방법2. 성능 안좋지만 연습
SELECT COUNT(MAX(USER_ID))
FROM TBL_REPLY 
GROUP BY USER_ID;			-- 1. 가장 많이 댓글을 작성한 유저ID의 갯수, 5개

SELECT USER_ID						-- 3. USER_ID를 조회, USER_ID 6
FROM TBL_REPLY
GROUP BY USER_ID
HAVING COUNT(USER_ID) = (			-- 2. USER_ID를 셋을 때의 갯수와 동일할 때의 
	SELECT COUNT(MAX(USER_ID))		-- 1. 가장 많이 댓글을 작성한 유저ID의 갯수와
	FROM TBL_REPLY 
	GROUP BY USER_ID	
);

SELECT USER_ID						-- 3. USER_ID를 조회
FROM TBL_REPLY
GROUP BY USER_ID
HAVING USER_ID = (					-- 2. USER_ID와 같을 때의
	SELECT USER_ID					-- 1. 가장 많이 댓글을 작성한 유저ID의 갯수와 USER_ID를 셋을 때의 갯수와 동일할 때의 USER_ID 6을 조회한 게
	FROM TBL_REPLY
	GROUP BY USER_ID
	HAVING COUNT(USER_ID) = (
		SELECT COUNT(MAX(USER_ID))
		FROM TBL_REPLY 
		GROUP BY USER_ID	
	)
);

SELECT *			-- 3. 전체테이터 출력 ==> 결국 댓글 가장 많이 달은 유저의 전체데이터 출력
FROM TBL_USER 
WHERE ID = (		-- 2. USER테이블의 ID와 동일할 때
	SELECT USER_ID	-- 1. 가장 많이 댓글을 작성한 유저ID의 갯수와 USER_ID를 셋을 때의 갯수와 동일할 때의 USER_ID 6을 조회한 게 USER_ID와 같을 때의  USER_ID를 조회한 게
	FROM TBL_REPLY
	GROUP BY USER_ID
	HAVING USER_ID = (
		SELECT USER_ID
		FROM TBL_REPLY
		GROUP BY USER_ID
		HAVING COUNT(USER_ID) = (
			SELECT COUNT(MAX(USER_ID))
			FROM TBL_REPLY 
			GROUP BY USER_ID	
		)
	)
);




-- 댓글이 가장 많이 달린 인기 게시글 조회
-- 알고리즘: COUNT로 댓글 가장 많이 단 POST_ID조회
SELECT *
FROM TBL_REPLY;

SELECT MAX(COUNT(POST_ID))		-- 최대 게시글 개수 즉, 가장 댓글이 많이 달린 게시글의 수, 3개
FROM TBL_REPLY
GROUP BY POST_ID;

SELECT POST_ID					-- 3. 게시글ID를 조회
FROM TBL_REPLY
GROUP BY POST_ID
HAVING COUNT(POST_ID) IN (		-- 2. 게시글ID 컬럼의 중복값을 셋을 때랑 같은 경우
	SELECT MAX(COUNT(POST_ID))	-- 1. 가장 댓글이 많이 달린 게시글의 수가
	FROM TBL_REPLY
	GROUP BY POST_ID
);

SELECT *							-- 5. 그 게시글의 전체데이터 조회
FROM TBL_POST
WHERE ID IN (						-- 4. POST테이블의 ID와 일치하면
	SELECT POST_ID					-- 3. 게시글ID를 조회하여
	FROM TBL_REPLY
	GROUP BY POST_ID
	HAVING COUNT(POST_ID) IN (		-- 2. 게시글ID 컬럼의 중복값을 셋을 때랑 같은 경우
		SELECT MAX(COUNT(POST_ID))	-- 1. 가장 댓글이 많이 달린 게시글의 수가
		FROM TBL_REPLY
		GROUP BY POST_ID
	)
);

	-- 방법2. ROWNUM으로 가상의 행 번호를 가져옴
SELECT COUNT(POST_ID)
FROM TBL_REPLY
GROUP BY POST_ID;				-- GROUP BY로 같은 POST_ID 별로 묶어서 카운트 셈. 3 1 3 1 1 나옴

SELECT POST_ID
FROM TBL_REPLY;					-- 댓글테이블에 있는 게시글ID. 1 3 4 5 1 4 2 4 1 나옴

SELECT POST_ID
FROM TBL_REPLY
GROUP BY POST_ID				-- 1. GROUP BY로 같은 POST_ID 별로 묶어서
ORDER BY POST_ID DESC;			-- 2. ID가 높은 번호에서 낮은 순으로 내림차순. 5 4 3 2 1 나옴

SELECT POST_ID
FROM TBL_REPLY
GROUP BY POST_ID				-- 1. GROUP BY로 같은 POST_ID 별로 묶어서
ORDER BY COUNT(POST_ID) DESC;	-- 2. 게시글이 많은 순서에서 내림차순 출력. 1 4 2 5 3 나옴 (게시글 수가 같을 때 출력순서는 오라클 마음)
	-- 1행(POST_ID 1)과 2행(POST_ID 4)이 제일 댓글이 많은 점을 사용해서 
SELECT *							-- 4. 게시글 전체 데이터 조회
FROM TBL_POST
WHERE ID IN (						-- 3. 그 POST_ID가 게시글테이블의 ID와 같으면
   SELECT POST_ID					-- 2. POST_ID를 조회해서
   FROM (
      SELECT POST_ID
      FROM TBL_REPLY							-- FROM절에 서브쿼리를 넣는 이유 :  
      GROUP BY POST_ID								-- ROWNUM은 SELECT 결과가 출력될 때 붙는 가상의 행 번호로
      ORDER BY COUNT(POST_ID) DESC					-- SELECT과 WHERE절에만 쓸 수 있어서 WHERE절의 ROWNUM이 적절하게 동작하기 위한 위치임. 
   )
   WHERE ROWNUM <= 2 				-- 1. FROM절(서브쿼리 결과값)에서 행 번호(서브쿼리 결과값)가 2와 같거나 작을 때
);

SELECT ROWNUM
FROM TBL_POST
WHERE ID IN (						-- 이 코드가 에러 나는 이유 : IN()에는 값이 와야하는데, ORDER BY는 정렬이라서 WHERE절 성립 안됨.
	SELECT POST_ID 
	FROM TBL_REPLY
	GROUP BY POST_ID 
	ORDER BY COUNT(POST_ID) DESC
);
	-- ↑ 이 코드를 의도에 맞게 쓰려면 ↓와 같이 쓴다. 
SELECT ROWNUM
FROM TBL_POST
WHERE ID IN (						
	SELECT POST_ID 
	FROM TBL_REPLY
	GROUP BY POST_ID
);						-- 가상의 행 번호 부여




-- 댓글과 게시글을 둘 다 작성한 유저 조회
-- 알고리즘: WHERE (댓글을 단 유저ID) IN (게시글 작성한 유저ID) 일 때의 SELECT * FROM TBL_USER;
SELECT DISTINCT USER_ID
FROM TBL_REPLY;			-- 1 2 3 4 6

SELECT DISTINCT USER_ID
FROM TBL_POST;			-- 1 2 3 5

SELECT *
FROM TBL_USER
WHERE ID IN (
		SELECT DISTINCT USER_ID
		FROM TBL_REPLY
) 
AND ID IN (
		SELECT DISTINCT USER_ID
		FROM TBL_POST
);



-- 1) 제목에 맥북을 포함하고 있는 게시글에 달린 댓글 조회
-- 알고리즘: 제목에 맥북을 포함하고 있는 게시글테이블의 ID 조회하고, 댓긅테이블에 그 POST ID를 확인
-- 			댓글테이블에 동일한 POST ID가 여러개라 어떤 게시글의 댓글을 조회할지 모름 ==> 그래서 1. 문자열 포함? 2. 제목에 맥북을 포함하고 있는 게시글테이블의 USER ID로 ?
SELECT * FROM TBL_POST tp ;
SELECT * FROM TBL_REPLY tr ;

SELECT ID
FROM TBL_POST
WHERE POST_TITLE LIKE '%맥북%';

SELECT REPLY_CONTENT 
FROM TBL_REPLY
WHERE POST_ID = (
	SELECT ID
	FROM TBL_POST
	WHERE POST_TITLE LIKE '%맥북%'
)


-- 2) 내용에 컴퓨터를 포함하고 있는 글을 작성한 유저의 이메일
-- 알고리즘: POST_CONTENT LIKE '%컴퓨터%'
SELECT USER_EMAIL
FROM TBL_USER 
WHERE ID IN (
	SELECT USER_ID
	FROM TBL_POST tp 
	WHERE POST_CONTENT LIKE '%컴퓨터%'
);


-- 3) 내용에 고장을 포함하고 있는 글에 댓글을 작성한 유저 조회
-- 알고리즘: POST_CONTENT LIKE '%고장%'
SELECT USER_ID
FROM TBL_REPLY tr 
WHERE ID IN (
	SELECT POST_ID 
	FROM TBL_POST tp 
	WHERE POST_CONTENT LIKE '%고장%'
);

SELECT * FROM TBL_POST;
SELECT * FROM TBL_REPLY tr ;

SELECT *
FROM TBL_USER
WHERE ID = (
	SELECT USER_ID
	FROM TBL_REPLY
	WHERE ID IN (
		SELECT POST_ID 
		FROM TBL_POST
		WHERE POST_CONTENT LIKE '%고장%'
	)
);


-- 4) 경기도에 거주하면서 댓글을 단 사용자 조회
-- 알고리즘: USER_ADDRESS '경기도%'
SELECT * FROM TBL_USER tu ;				 -- ID 2번만 경기도 
SELECT * FROM TBL_REPLY tr ;

SELECT ID
FROM TBL_USER 
WHERE USER_ADDRESS LIKE '경기도%';		-- ID 2번

SELECT USER_ID
FROM TBL_REPLY tr 
WHERE USER_ID = ( 
	SELECT ID
	FROM TBL_USER 
	WHERE USER_ADDRESS LIKE '경기도%'
);

SELECT *
FROM TBL_USER
WHERE ID = (
	SELECT USER_ID
	FROM TBL_REPLY tr 
	WHERE USER_ID = ( 
		SELECT ID
		FROM TBL_USER 
		WHERE USER_ADDRESS LIKE '경기도%'
	)
);


	
	



-- 정답은 밑에
-- 5) 가장 나이가 어린 사용자가 작성한 게시글들 조회, ROWNUM





-- 6) 서울에 살고 있는 인원 수에 해당하는 번호에 게시글 조회
-- 알고리즘: COUNT(USER_ADDRESS LIKE AS '서울%')
	SELECT *
	FROM TBL_USER;
	
	SELECT SUM(COUNT(USER_ADDRESS))
	FROM TBL_USER 
	GROUP BY USER_ADDRESS
	HAVING USER_ADDRESS LIKE '서울%';			-- 인원수 3명 ==> 게시글의 번호(ID)가 됨.

	SELECT *
	FROM TBL_POST tp 
	WHERE ID = (
		SELECT SUM(COUNT(USER_ADDRESS))
		FROM TBL_USER 
		GROUP BY USER_ADDRESS
		HAVING USER_ADDRESS LIKE '서울%'
	);

-- 7) 주소가 '구'로 끝나는 유저가 작성한 게시글에 달린 모든 댓글들 조회
	-- 알고리즘: USER_ADDRESS LIKE '%구'
	SELECT *
	FROM TBL_USER S
	WHERE USER_ADDRESS LIKE '%구';				-- 1. 에서 유저테이블의 ID (1 3 4 5)를

	SELECT *
	FROM TBL_POST tp ;							-- 2. 에 사용하여 
	
	SELECT *									
	FROM TBL_POST tp
	WHERE USER_ID IN (							-- 3. 유저테이블의 ID와 게시글테이블의 USER_ID가 일치할 때
		SELECT S.ID
		FROM TBL_USER S
		WHERE USER_ADDRESS LIKE '%구'
	);											-- 4. 게시글테이블의 ID를 조회 (유저ID 4는 게시글을 안남겨서 유저1 3 5가 남긴 게시글 ID만 나옴)
	
	SELECT * FROM TBL_REPLY tr ;				-- 5. 4.의 결과값을 5.에 사용하여
	
	SELECT REPLY_CONTENT						-- 7. 댓글테이블의 POST_ID에 달린 댓글 조회
	FROM TBL_REPLY tr 
	WHERE POST_ID IN (							-- 6. 댓글테이블의 POST_ID와
		SELECT ID								-- 		게시글 테이블의 ID 1 3 4 6과 일치하면
		FROM TBL_POST tp
		WHERE USER_ID IN (						
			SELECT S.ID
			FROM TBL_USER S
			WHERE USER_ADDRESS LIKE '%구'
		)
	);

-- 8) 댓글에 '한민'이가 포함된 게시글에 달린 모든 댓글 조회


-- 9) 평균 댓글 개수보다 많이 달린 게시글을 작성한 유저


-- 10) 가장 댓글을 적게 작성한 유저가 작성한 게시글












-- 5) 가장 나이가 어린 사용자가 작성한 게시글들 조회, ROWNUM
SELECT * 
FROM TBL_POST
WHERE USER_ID IN (
   SELECT ID
   FROM (
      SELECT * 
      FROM TBL_USER
      ORDER BY USER_BIRTH DESC
   )
   WHERE ROWNUM <= 3
);

-- 6) 서울에 살고 있는 인원 수에 해당하는 번호에 게시글 조회

SELECT * 
FROM TBL_POST 
WHERE ID = (
   SELECT COUNT(ID)
   FROM TBL_USER
   WHERE USER_ADDRESS LIKE '%서울%'
);

-- 7) 주소가 '구'로 끝나는 유저가 작성한 게시글에 달린 모든 댓글들 조회
SELECT *
FROM TBL_REPLY
WHERE POST_ID IN (
   SELECT ID
   FROM TBL_POST
   WHERE USER_ID IN (
      SELECT ID
      FROM TBL_USER
      WHERE USER_ADDRESS LIKE '%구'
   )
);

-- 8) 댓글에 '한민'이가 포함된 게시글에 달린 모든 댓글 조회

SELECT *
FROM TBL_REPLY
WHERE POST_ID IN (
   SELECT ID
   FROM TBL_POST
   WHERE ID IN (
      SELECT POST_ID
      FROM TBL_REPLY
      WHERE REPLY_CONTENT LIKE '%한민%'
   )
);

-- 9) 평균 댓글 개수보다 많이 달린 게시글을 작성한 유저
SELECT * 
FROM TBL_USER
WHERE ID IN (
   SELECT USER_ID
   FROM TBL_POST
   WHERE ID IN (
      SELECT POST_ID
      FROM TBL_REPLY
      GROUP BY POST_ID
      HAVING COUNT(POST_ID) > (
         SELECT AVG(COUNT(POST_ID))
         FROM TBL_REPLY
         GROUP BY POST_ID
      )
   )
);

-- 10) 가장 댓글을 적게 작성한 유저가 작성한 게시글
SELECT * 
FROM TBL_POST 
WHERE USER_ID IN (
   SELECT USER_ID
   FROM (
      SELECT USER_ID
      FROM TBL_REPLY
      GROUP BY USER_ID
      ORDER BY COUNT(USER_ID)
   )
   WHERE ROWNUM <= 4
);