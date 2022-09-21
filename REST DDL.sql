DROP TABLE RestingArea CASCADE CONSTRAINTS; 
CREATE TABLE RestingArea (
	svarCd	VARCHAR2(300),
	svarNm	VARCHAR2(300)	NULL,
	svarAddr	VARCHAR2(300)	NULL,
	routeNm	VARCHAR2(300)	NULL,
	avarAddr	VARCHAR2(300)	NULL,
	gudClssNm	VARCHAR2(300)	NULL,
	rprsTelNo	VARCHAR2(300)	NULL,
    PRIMARY KEY (svarCd)
);
desc res_user;
SELECT
    * FROM res_user;
    
SELECT
    * FROM bookmark_res;    
    
select * FROM restingarea;

INSERT INTO restingarea VALUES 
('000485','건천(부산)주유소','경북 경주시 건천읍 경부고속도로 77','경부선','경상','하행','0547514600');
INSERT INTO restingarea VALUES 
('000486','건천(서울)주유소','경북 경주시 건천읍 경부고속도로 77','경부선','경상','상행','0547514600');
INSERT INTO restingarea VALUES 
('000054','건천(부산)휴게소','경북 경주시 건천읍 방내리 14','경부선','경상','하행','0547517810');
INSERT INTO restingarea VALUES 
('000055','건천(서울)휴게소','경북 경주시 건천읍 방내리 14','경부선','경상','상행','0547517810');

select * FROM restingarea WHERE svarcd = 900572;
SELECT * FROM convenient;

-- 노선별 검색
SELECT * FROM restingarea WHERE routenm = '경부선';

-- 노선별 검색 + 상하행검색 ( * => 무엇을 보여주면 좋을지 선택!)
SELECT * FROM restingarea WHERE routenm = '경부선' and gudclssnm = '하행';

-- 선택 휴게소가 보유한 편의시설 리스트   
SELECT c.psname FROM  convenient c
JOIN restingarea r ON(c.stdrestcd = r.svarcd)
WHERE r.svarnm ='건천(부산)휴게소';

-- 휴게소 세부사항 ★편의시설★
SELECT * FROM convenient c
JOIN restingarea r ON(c.stdrestcd = r.svarcd) 
WHERE r.svarnm ='건천(부산)휴게소' 
and c.psname = '매점';

-- 지역별 검색
SELECT svarnm FROM restingarea WHERE avaraddr = '강원권';

-- 휴게소 세부사항
SELECT * FROM  convenient c
JOIN restingarea r ON(c.stdrestcd = r.svarcd) 
WHERE r.svarnm ='건천(부산)휴게소';

-- 휴게소 세부사항 ★편의시설★
SELECT * FROM  convenient c
JOIN restingarea r ON(c.stdrestcd = r.svarcd) 
WHERE r.svarnm ='시흥하늘휴게소' 
and c.psname = 'ATM';

DROP TABLE Food CASCADE CONSTRAINTS;
CREATE TABLE Food (
	foodSeq	NUMBER,
	svarCd	VARCHAR2(300),
	foodNm	VARCHAR2(300)	NULL,
	foodCost	NUMBER	NULL,
	recommendyn	 NUMBER DEFAULT 0,
	seasonMenu	VARCHAR2(300),
	bestfoodyn NUMBER DEFAULT 0,
	premiumyn	NUMBER DEFAULT 0,
    PRIMARY KEY (foodSeq),
    FOREIGN KEY (SVARCD) REFERENCES RestingArea
);

SELECT * FROM food;

-- 각 컨트롤러에서 데이터 넣으시면 됩니다!


INSERT INTO food VALUES(5830, '000485','냉우동',7000,0,'s',0,0);
INSERT INTO food VALUES(5831, '000054','사누끼우동',6000,0,'4',0,0);
INSERT INTO food VALUES(5832, '000485','튀김우동',8000,0,'w',0,0);
INSERT INTO food VALUES(5833, '000054','어묵우동',5000,0,'4',0,0);

-- 휴게소검색 (휴게소가 전부 나온다!)
SELECT svarnm  
FROM restingarea 
WHERE svarnm  LIKE '%건천%';

-- 가격별검색 ( 선택된 휴게소 음식 + 가격) => 10000원이상 기준을 정해야함!
SELECT f.foodnm, f.foodcost
FROM food f
JOIN restingarea r ON (f.svarcd = r.svarcd)
WHERE f.foodcost >= 6000 
AND r.svarNm = '건천(부산)휴게소';

-- 프리미엄 메뉴검색
SELECT foodnm
FROM food f
JOIN restingarea r ON(f.svarcd = r.svarcd)
WHERE f.premiumyn = 0
and stdrestnm = '건천(부산)휴게소';

-- 추천 메뉴 검색
SELECT foodnm
FROM food f
JOIN restingarea r ON(f.svarcd = r.svarcd)
WHERE f.bestfoodyn = 0
and stdrestnm = '건천(부산)주유소';

-- 계절메뉴 검색 1
SELECT foodnm
FROM food f
JOIN restingarea r ON(f.svarcd = r.svarcd)
WHERE f.seasonmenu = 'w'
and stdrestnm = '건천(부산)주유소';

-- 계절메뉴 검색2
SELECT foodnm
FROM food f
JOIN restingarea r ON(f.svarcd = r.svarcd)
WHERE f.seasonmenu = 's'
and r.stdrestnm = '건천(부산)주유소';

-- 상세메뉴 보기
SELECT foodnm,foodcost
FROM food f
JOIN restingarea r ON(f.svarcd = r.svarcd)
WHERE r.stdrestnm = '건천(부산)휴게소'
and f.foodnm = '우동';

-- 음식명 검색  ★노선이 나와야 함
SELECT routenm 
FROM restingarea r
JOIN food f ON(r.svarcd = f.svarcd)
WHERE f.foodnm LIKE '%우동%' GROUP BY routenm;

-- 음식명 + 노선선택 ★휴게소 이름
SELECT svarNm
FROM restingarea r
JOIN food f ON(r.svarcd = f.svarcd)
WHERE r.routenm = '경부선' 
and f.foodnm LIKE '%우동%'
GROUP BY svarNm;

-- 음식 리스트
SELECT f.foodnm
FROM food f
JOIN restingarea r ON(r.svarcd = f.svarcd)
WHERE r.svarNm = '강릉(인천)휴게소'
and f.foodnm LIKE '%우동%';

-- 상세메뉴 보기
SELECT foodnm,foodcost
FROM food f
JOIN restingarea r ON(f.svarcd = r.svarcd)
WHERE r.stdrestnm = '건천(부산)휴게소'
and f.foodnm = '사누끼우동';

DROP TABLE Convenient CASCADE CONSTRAINTS;
CREATE TABLE Convenient (
	psCode	VARCHAR2(300),
	stdrestCd	VARCHAR2(300)	NOT NULL,
	psName	VARCHAR2(300)	NULL,
	psDesc	VARCHAR2(300)	NULL,
	stime	VARCHAR2(300)	NULL,
    etime	VARCHAR2(300)	NULL
    --PRIMARY KEY (psCode)
   --FOREIGN KEY (stdrestCd) REFERENCES RestingArea -- 휴게소점검 후 조건 걸고 다시!!
);

SELECT * FROM Convenient;
--INSERT INTO convenient VALUES('08','000485','ex-화물차라운지','[코로나19로 최소인원 이용 가능] 화물차 운전자가 사용할 수 있는 샤워실, 수면실, 화장실이 운영되고 있음(남성만 가능, 무료)'
--,'05:00','21:00');
--INSERT INTO convenient VALUES('09','000054','경정비','장소 : 휴게소 진출로(주유소 측면) / 내용 : 차량 경정비','00:00','24:00');

--편의시설 검색
SELECT r.svarnm 
FROM  restingarea r
JOIN convenient c ON(c.stdrestcd = r.svarcd)
WHERE c.psname LIKE '%경정비%';

--편의시설 세부정보 수정!
SELECT c.* 
FROM convenient c
JOIN restingarea r ON(r.svarcd = c.stdrestcd)
WHERE stdrestnm = '건천(부산)휴게소'
and psname LIKE '%경정비%';


DROP TABLE Res_User CASCADE CONSTRAINTS;
CREATE TABLE Res_User (
	userKey	NUMBER,
	userId	VARCHAR2(300)	NULL,
	userpw	VARCHAR2(300)	NULL,
	userNm	VARCHAR2(300)	NULL,
	userPh	VARCHAR2(300)	NULL,
    PRIMARY KEY (userKey)
);

CREATE SEQUENCE userKey;
INSERT INTO res_user VALUES(USERKEY.nextval, 'test1', 'test1', '홍길동', '010-1111-1111');
INSERT INTO res_user VALUES(USERKEY.nextval, 'test2', 'test2', '송길동', '010-2222-2222');
SELECT * FROM res_user;

-- 로그인(ID 확인)
SELECT userid FROM res_user
WHERE userid = 'test1';
-- 로그인(PW 확인)
SELECT userpw FROM res_user
WHERE userpw = 'test1';


DROP TABLE Bookmark_Res CASCADE CONSTRAINTS;
CREATE TABLE Bookmark_Res (
	svarCd	VARCHAR2(300)	NOT NULL,
	userKey	NUMBER	NOT NULL,
	res_date	DATE   NULL,
    FOREIGN KEY (svarCd) REFERENCES RestingArea,
    FOREIGN KEY (userKey) REFERENCES Res_User
);

INSERT INTO bookmark_res VALUES('000485',22,SYSDATE);
INSERT INTO bookmark_res VALUES('000054',21,SYSDATE);

SELECT * FROM bookmark_res;

-- 유저가 즐겨찾기한 휴게소 리스트
SELECT r.stdrestnm 
FROM restingarea r
JOIN bookmark_res b ON(b.svarcd = r.svarcd)
WHERE b.userkey = 22;

-- 휴게소 선택하면 음식리스트1 (휴게소이름 + 음식)
SELECT r.stdrestnm, f.foodnm
FROM food f
JOIN bookmark_res b ON(b.svarcd = f.svarcd)
JOIN restingarea r ON(r.svarcd = f.svarcd)
WHERE b.userkey = 22;

-- 휴게소 선택하면 편의시설리스트 2 (휴게소이름 + 편의시설)
SELECT r.stdrestnm, c.psname
FROM convenient c
JOIN bookmark_res b ON(b.svarcd = c.svarcd)
JOIN restingarea r ON(r.svarcd = c.svarcd)
WHERE b.userkey = 22;

-- 휴게소 선택하면 휴게소정보 3
SELECT r.*
FROM restingarea r
JOIN bookmark_res b ON(b.svarcd = r.svarcd)
WHERE b.userkey = 22;

COMMIT;
--ROLLBACK;