-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECALCULOTASACONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECALCULOTASACONTPRO`;DELIMITER $$

CREATE PROCEDURE `CRECALCULOTASACONTPRO`(
# =======================================================================
# ----- Obtiene la tasa fija o variable de creditos contingentes--
# =========================================================================
	Par_CreditoID		BIGINT(12),
	Par_FormulaID 		INT(11) ,
	Par_TasaFija 		DECIMAL(12,4),
	Par_Fecha			DATE,
	Par_FecIniAmo		DATE,

	Par_EmpresaID		INT(11),
	OUT Par_TasaOut		DECIMAL(12,4),

    Par_Salida 			CHAR(1),    		-- indica una salida
	INOUT	Par_NumErr	INT(11),			-- parametro numero de error
	INOUT	Par_ErrMen	VARCHAR(400),		-- mensaje de error

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	-- declaracion de variables
	DECLARE	Var_PisoTasa		DECIMAL(12,4);
	DECLARE	Var_TechoTasa		DECIMAL(12,4);
	DECLARE	Var_TasaBase		INT;
	DECLARE	Var_SobreTasa		DECIMAL(12,4);
	DECLARE	Var_FecTas			DATETIME;
    DECLARE Var_Control			VARCHAR(100);
    DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_FecFinMesAnt 	DATE;
	DECLARE Var_FecIniMesAnt	DATE;
	DECLARE Var_numTra			BIGINT;
    -- declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	For_TasaFija		INT;
	DECLARE	For_BasePuntos		INT;
	DECLARE	For_BaPunPisTecho	INT;
	DECLARE For_TBUltDiaMesPunt INT; -- Tasa Base Ultimo dia del Mes + Punto
    DECLARE Salida_SI			CHAR(1);
    -- asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	For_TasaFija			:= 1;
	SET	For_BasePuntos			:= 2;
	SET	For_BaPunPisTecho		:= 3;
	SET	For_TBUltDiaMesPunt		:= 4; -- Tasa Base Ultimo dia del Mes + Punto
    SET Salida_SI				:= 'S';

   ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CRECALCULOTASACONTPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF(Par_FormulaID = For_TasaFija) THEN
			SET Par_TasaOut := Par_TasaFija ;
		ELSE
			IF(Par_FormulaID = For_BasePuntos)THEN

				SELECT TasaBase, SobreTasa
					INTO Var_TasaBase, Var_SobreTasa
				FROM CREDITOSCONT
					WHERE CreditoID = Par_CreditoID;

				SELECT  MAX(Fecha) INTO Var_FecTas
					FROM `HIS-TASASBASE`
						WHERE TasaBaseID = Var_TasaBase;

				SET	Var_FecTas := IFNULL(Var_FecTas, Fecha_Vacia);

				SET Var_numTra:= (SELECT MAX(NumTransaccion)
									FROM `HIS-TASASBASE`
										WHERE TasaBaseID = Var_TasaBase
											AND Fecha= Var_FecTas );

				SELECT  Valor INTO Par_TasaOut
					FROM `HIS-TASASBASE`
					WHERE TasaBaseID = Var_TasaBase
						AND Fecha = Var_FecTas
							AND NumTransaccion=Var_numTra;

				SET	Par_TasaOut := IFNULL(Par_TasaOut, Entero_Cero);
				SET	Par_TasaOut := Par_TasaOut + Var_SobreTasa;
			ELSE
				IF (Par_FormulaID = For_BaPunPisTecho)THEN

					SELECT TasaBase, SobreTasa, PisoTasa, TechoTasa
						INTO Var_TasaBase, Var_SobreTasa, Var_PisoTasa, Var_TechoTasa
					FROM CREDITOSCONT
						WHERE CreditoID = Par_CreditoID;

					SELECT  MAX(Fecha) INTO Var_FecTas
						FROM `HIS-TASASBASE`
							WHERE TasaBaseID = Var_TasaBase;

					SET	Var_FecTas := IFNULL(Var_FecTas, Fecha_Vacia);

					SET Var_numTra := (SELECT MAX(NumTransaccion) FROM `HIS-TASASBASE` WHERE TasaBaseID = Var_TasaBase AND Fecha= Var_FecTas);

					SELECT  Valor INTO Par_TasaOut
						FROM `HIS-TASASBASE`
							WHERE TasaBaseID = Var_TasaBase
							AND Fecha= Var_FecTas
								AND NumTransaccion=Var_numTra;

					SET	Par_TasaOut := IFNULL(Par_TasaOut, Entero_Cero);
					SET	Par_TasaOut := Par_TasaOut + Var_SobreTasa;

					IF (Par_TasaOut > Var_TechoTasa) THEN
						SET	Par_TasaOut := Var_TechoTasa;
					END IF;

					IF (Par_TasaOut < Var_PisoTasa)THEN
						SET	Par_TasaOut := Var_PisoTasa;
					END IF;

				ELSE
					IF (Par_FormulaID = For_TBUltDiaMesPunt)THEN

						SET	Var_FecFinMesAnt := last_day(date_sub(Par_Fecha, INTERVAL 1 month));
						SET Var_FecIniMesAnt := date_sub(Var_FecFinMesAnt, INTERVAL DAYOFMONTH(Var_FecFinMesAnt)-1 DAY);

						-- Obtenemos Sobre tasa
						SELECT  Cre.TasaBase, Cre.SobreTasa
							INTO Var_TasaBase, Var_SobreTasa
						FROM CREDITOSCONT Cre
							WHERE Cre.CreditoID = Par_CreditoID;

						SELECT  MAX(Fecha) INTO Var_FecTas	FROM `HIS-TASASBASE`
							WHERE	TasaBaseID	= Var_TasaBase
								AND	Fecha >= Var_FecIniMesAnt
									AND	Fecha <= Var_FecFinMesAnt;

						SET	Var_FecTas := IFNULL(Var_FecTas, Fecha_Vacia);

						-- Obtenemos la tasa de la fecha del ultimo dia del mes anterior
						SET Var_numTra:= (SELECT MAX(NumTransaccion) FROM `HIS-TASASBASE` WHERE TasaBaseID = Var_TasaBase AND Fecha= Var_FecTas);

						SELECT  Valor INTO Par_TasaOut  -- Tasa base del mes anterior
							FROM `HIS-TASASBASE`
						WHERE TasaBaseID = Var_TasaBase
							AND Fecha = Var_FecTas
								AND NumTransaccion=Var_numTra;

						SET Par_TasaOut:= IFNULL(Par_TasaOut, Entero_Cero)+ IFNULL(Var_SobreTasa, Entero_Cero);
					ELSE
						SET Par_TasaOut = Entero_Cero;
					END IF;
				END IF;
			END IF;
		END IF;

        SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := 'Calculo Realizado Exitosamente.';
        SET Var_Control:= 'creditoID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT
			Par_NumErr          AS NumErr,
			Par_ErrMen          AS ErrMen,
			Var_Control         AS control,
			Par_TasaOut     	AS consecutivo;
END IF;
END TerminaStore$$