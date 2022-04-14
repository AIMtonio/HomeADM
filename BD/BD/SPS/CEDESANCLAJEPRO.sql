-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESANCLAJEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESANCLAJEPRO`;DELIMITER $$

CREATE PROCEDURE `CEDESANCLAJEPRO`(
# ============================================================================
# -------- SP QUE SE ENCARGA DE PAGAR LOS CEDES DURANTE EL VENC. MASIVO-------
# ============================================================================
    Par_Fecha           DATE,           -- Fecha de Operacion

    Par_Salida          CHAR(1),        -- Salida en Pantalla
    INOUT Par_NumErr    INT(11),        -- Salida en Pantalla Numero  de Error o Exito
    INOUT Par_ErrMen    VARCHAR(400),   -- Salida en Pantalla Mensaje de Error o Exito

    Par_EmpresaID       INT(11),        -- Auditoria
    Aud_Usuario         INT(11),        -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT(11),        -- Auditoria
    Aud_NumTransaccion  BIGINT(20)      -- Auditoria
)
TerminaStore : BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(1);
	DECLARE SalidaSI            CHAR(1);
	DECLARE SalidaNO            CHAR(1);
	DECLARE Var_FecBitaco       DATETIME;
	DECLARE ProcesoCede         INT(11);
	DECLARE Var_MinutosBit      INT(11);
	DECLARE Var_Capital         CHAR(1);
	DECLARE Var_CapitalInteres  CHAR(2);
	DECLARE Var_NumCedes        INT(11);
	DECLARE ProgramaVencMasivo  VARCHAR(100);
	DECLARE ProcesoCierre       CHAR(1);
	DECLARE Pago_SiReinversion  CHAR(1);
    DECLARE Entero_Uno			INT(11);
    DECLARE Fecha_Vacia         DATE;
    DECLARE NoCliEsp		 	INT;
	DECLARE CliProcEspecifico 	VARCHAR(20);


	-- Declaracion de variables
	DECLARE Var_ContadorTotal   INT;
	DECLARE Var_ContadorExito   INT;
	DECLARE Var_Control         VARCHAR(200);
    DECLARE	Var_FechaBatch		DATE;
    DECLARE Var_EsCritico		CHAR(1);
	DECLARE Var_CliProEsp	  	INT;

	-- Asignacion de constantes
	SET SalidaSI            	:=  'S';    -- Constante Salida SI 'S'
	SET SalidaNO            	:=  'N';    -- Constante Salida NO 'N'
	SET Entero_Cero         	:=  0;      -- Valor Entero Cero
	SET ProcesoCede         	:=  1314;   -- ID Proceso Batch 'CIERRE DIARIO CEDES'
	SET Var_Capital         	:= 'C';     -- Valor Var_Capital
	SET Var_CapitalInteres  	:= 'CI';    -- Valor Var_Capital Interes
	SET ProcesoCierre       	:= 'C';     -- Valor Cierre
	SET ProgramaVencMasivo  	:='/microfin/cedesVencimientoMasivo.htm';	-- Programa Vencimiento Masivo CEDES
	SET Pago_SiReinversion  	:= 'S';	-- Tipo de Cedes que SI Reinvierten
	SET Entero_Uno				:= 1;	-- Entero Uno
    SET Fecha_Vacia         	:= '1900-01-01';
    SET NoCliEsp				:=24;	-- Cliente CrediClub
	SET CliProcEspecifico		:='CliProcEspecifico';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDESANCLAJEPRO');
				SET Var_Control ='SQLEXCEPTION';
			END;



		SET Aud_FechaActual := NOW();
		SET Var_FecBitaco   := Aud_FechaActual;

  -- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH

        SELECT ValorParametro INTO Var_CliProEsp
        FROM PARAMGENERALES
        where LlaveParametro= CliProcEspecifico;

		CALL BITACORABATCHCON (
			ProcesoCede,		Par_Fecha,		Var_FechaBatch,		Entero_Uno,		Par_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN
			-- OBTENIENDO LAS CEDES ANCLADAS
			TRUNCATE TABLE TEMPCEDESANCLADAS;
			INSERT INTO TEMPCEDESANCLADAS
				SELECT  anc.CedeOriID,  SUM(tmp.Monto), SUM(tmp.InteresRecibir)
					FROM 	CEDESANCLAJE anc
							INNER JOIN TEMPCEDES tmp ON anc.CedeAncID = tmp.CedeID
					GROUP BY anc.CedeOriID;

			-- ACTUALIZANDO EL MONTO A REINVERTIR DE LAS CEDES ANCLADAS
			UPDATE TEMPCEDES Tem, TEMPCEDESANCLADAS Anc SET
						Tem.MontoReinvertir =   Tem.MontoReinvertir  +
										CASE WHEN (Tem.Reinvertir = Var_Capital)        THEN Anc.Monto
											 WHEN (Tem.Reinvertir = Var_CapitalInteres) THEN (Anc.Monto + Anc.InteresRecibir)
										END
				WHERE 	Tem.CedeID	= Anc.CedeID;

			-- VERIFICANDO SI HAY CEDES ANCLADAS EN LA TABLA TEMPORAL
			SELECT  COUNT(CedeID) INTO  Var_NumCedes FROM   TEMPCEDESANCLADAS;

			-- MANDAMOS A PAGAR LAS CEDES ANCLADAS
			IF(Var_NumCedes > Entero_Cero) THEN
					IF (Var_CliProEsp = NoCliEsp) THEN
						     CALL CEDEPAGOCIERREPRO024(
							Par_Fecha,          ProcesoCierre,      Pago_SIReinversion,     SalidaNO,       Par_NumErr,
							Par_ErrMen,         Var_ContadorTotal,  Var_ContadorExito,      Par_EmpresaID,  Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);
						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

					ELSE
                        CALL CEDEPAGOCIERREPRO(
							Par_Fecha,          ProcesoCierre,      Pago_SIReinversion,     SalidaNO,       Par_NumErr,
							Par_ErrMen,         Var_ContadorTotal,  Var_ContadorExito,      Par_EmpresaID,  Aud_Usuario,
							Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);
						IF(Par_NumErr != Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
			END IF;

			-- BORRAMOS LAS CEDES HIJAS QUE PERTENECEN AL ANCLAJE
			DELETE Tem
				FROM 	TEMPCEDES Tem
				WHERE 	Tem.CedeID IN (SELECT CedeAncID
										FROM TEMPCEDESANCLADAS Ant,
											  CEDESANCLAJE Cla
										WHERE Ant.CedeID = Cla.CedeOriID);
			-- SE BORRA LA TABLA TEMPORAL
			TRUNCATE TABLE TEMPCEDESANCLADAS;

			IF(Par_NumErr = Entero_Cero) THEN
				SET Par_NumErr      :=  Entero_Cero;
				SET Par_ErrMen      :=  'Ajuste CEDES Anclados Reaizados Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			/*Programa vencimiento masivo cedes*/
			IF(Aud_ProgramaID!=ProgramaVencMasivo)THEN
				CALL BITACORABATCHALT(
					ProcesoCede,        Par_Fecha,          Var_MinutosBit,    	Par_EmpresaID,      Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,       Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco   := NOW();
		END IF;

		SET Par_NumErr      :=  Entero_Cero;
		SET Par_ErrMen      :=  'Ajuste CEDES Anclados Realizados Exitosamente.';

	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen;
    END IF;
END TerminaStore$$