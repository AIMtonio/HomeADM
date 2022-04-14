-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESTERROR
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESTERROR`;DELIMITER $$

CREATE PROCEDURE `TESTERROR`(
	Par_Fecha	date
	)
BEGIN

DECLARE Var_InversionID INT;
DECLARE Error_Key INT DEFAULT 0;
DECLARE consec INT DEFAULT 0;
DECLARE descri char;
DECLARE Var_FecBitaco datetime;


DECLARE CURSORINVER CURSOR FOR
	(select InversionID
		from INVERSIONES
		where	Estatus	= 'N'
		  and	FechaInicio	<= Par_Fecha
		  and	InversionID	< 100000);

SET AUTOCOMMIT=0;
Set consec = 0;

set Var_FecBitaco = now();

DELETE FROM TMPINVER;

OPEN CURSORINVER; BEGIN

	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
		FETCH CURSORINVER into
			Var_InversionID;
		START TRANSACTION;
		BEGIN

			DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;


			set Error_Key = 0;
			insert TMPINVER VALUES(Var_InversionID);

			if consec = 0 or consec = 2 then
				insert TMPINVER VALUES(999999);
			end if;
			if consec = 1 or consec = 3 then
				insert TMPERROR values(1, descri);
			end if;
			if consec = 4 then
				call PARAMETROSSISCON();
			end if;

		END;
		if Error_Key = 0 then
			COMMIT;
		end if;
		if Error_Key = 1 then
			ROLLBACK;
			START TRANSACTION;
				insert TMPERROR values(1, concat('ERROR DE SQL GENERAL', convert(Var_InversionID,char)));
			COMMIT;
		end if;
		if Error_Key = 2 then
			ROLLBACK;
			START TRANSACTION;
				insert TMPERROR values(2, concat('Error al Insertar, Llave Duplicada', convert(Var_InversionID,char)));
			COMMIT;
		end if;
		if Error_Key = 3 then
			ROLLBACK;
			START TRANSACTION;
				insert TMPERROR values(3, concat('Error al llamar a Store Procedure',convert(Var_InversionID,char)));
			COMMIT;
		end if;
		if Error_Key = 4 then
			ROLLBACK;
			START TRANSACTION;
				insert TMPERROR values(4, concat('Error al Insertar, Valores Nulos',convert(Var_InversionID,char)));
			COMMIT;
		end if;
		set consec = consec +1;
	End LOOP;

END;
CLOSE CURSORINVER;

SELECT TIMESTAMPDIFF(SECOND, Var_FecBitaco, now()) as minutosman;

END$$