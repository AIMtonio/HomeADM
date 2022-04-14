-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGAMORLIBPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGAMORLIBPRO`;DELIMITER $$

CREATE PROCEDURE `PAGAMORLIBPRO`(

	Par_NumTransac		INT,


    Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN


    DECLARE Var_Consecutivo    	INT(11);
    DECLARE Var_FechaInicio    	DATE;
    DECLARE Var_FechaVence     	DATE;
    DECLARE Var_FechaSistema   	DATE;

	DECLARE Var_NumDias	   	   	INT;
	DECLARE Var_ConsAmortiza   	INT(11);
    DECLARE Var_FechaVenAmor   	DATE;
    DECLARE FechaVig		   	DATE;
    DECLARE Var_EsHabil			CHAR;


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;


	DECLARE TMPFECHAAMORPAGLIBRES CURSOR FOR
	SELECT Tmp_Consecutivo,Tmp_FecIni,Tmp_FecFin
	FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransac;


	DECLARE TMPFECHAEXIPAGLIBRES CURSOR FOR
	SELECT Tmp_Consecutivo,Tmp_FecFin
	FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransac;



	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;


	SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);


	SELECT	DATEDIFF(Var_FechaSistema,Tmp_FecIni) INTO Var_NumDias
		FROM TMPPAGAMORSIM
		WHERE NumTransaccion = Par_NumTransac
		AND Tmp_Consecutivo = 1;


	IF(Var_NumDias > Entero_Cero) THEN

		OPEN TMPFECHAAMORPAGLIBRES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP

				FETCH TMPFECHAAMORPAGLIBRES INTO
						Var_Consecutivo, Var_FechaInicio, Var_FechaVence;


				UPDATE TMPPAGAMORSIM
					SET Tmp_FecIni = DATE_ADD(Var_FechaInicio, INTERVAL Var_NumDias DAY),
						Tmp_FecFin = DATE_ADD(Var_FechaVence, INTERVAL Var_NumDias DAY)
				WHERE Tmp_Consecutivo = Var_Consecutivo
				AND NumTransaccion = Par_NumTransac;

				END LOOP;
			END;
		CLOSE TMPFECHAAMORPAGLIBRES;


		OPEN TMPFECHAEXIPAGLIBRES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP

				FETCH TMPFECHAEXIPAGLIBRES INTO Var_ConsAmortiza, Var_FechaVenAmor;


				CALL DIASFESTIVOSCAL(
							Var_FechaVenAmor,	Entero_Cero,		FechaVig,			Var_EsHabil,		Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);


				UPDATE TMPPAGAMORSIM
					SET Tmp_FecVig = FechaVig
				WHERE Tmp_Consecutivo = Var_ConsAmortiza
				AND NumTransaccion = Par_NumTransac;

				END LOOP;
			END;
		CLOSE TMPFECHAEXIPAGLIBRES;
	END IF;
END$$