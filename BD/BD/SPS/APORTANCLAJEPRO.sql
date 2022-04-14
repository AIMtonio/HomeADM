-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTANCLAJEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTANCLAJEPRO`;DELIMITER $$

CREATE PROCEDURE `APORTANCLAJEPRO`(
# ============================================================================
# -------- SP QUE SE ENCARGA DE PAGAR LOS APORTACIONES DURANTE EL VENC. MASIVO-------
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
	DECLARE ProcesoAport         INT(11);
	DECLARE Var_MinutosBit      INT(11);
	DECLARE Var_Capital         CHAR(1);
	DECLARE Var_CapitalInteres  CHAR(2);
	DECLARE Var_NumAports        INT(11);
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

	SET SalidaSI            	:=  'S';
	SET SalidaNO            	:=  'N';
	SET Entero_Cero         	:=  0;
	SET ProcesoAport         	:=  1514;
	SET Var_Capital         	:= 'C';
	SET Var_CapitalInteres  	:= 'CI';
	SET ProcesoCierre       	:= 'C';
	SET ProgramaVencMasivo  	:='/microfin/vencMasivoAportVista.htm';
	SET Pago_SiReinversion  	:= 'S';
	SET Entero_Uno				:= 1;
	SET Fecha_Vacia         	:= '1900-01-01';
	SET NoCliEsp				:=24;				-- Cliente CrediClub
	SET CliProcEspecifico		:='CliProcEspecifico';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-APORTANCLAJEPRO');
				SET Var_Control :='SQLEXCEPTION';
			END;



		SET Aud_FechaActual := NOW();
		SET Var_FecBitaco   := Aud_FechaActual;

		SELECT ValorParametro INTO Var_CliProEsp
		FROM PARAMGENERALES
		where LlaveParametro= CliProcEspecifico;

		CALL BITACORABATCHCON (
			ProcesoAport,		Par_Fecha,		Var_FechaBatch,		Entero_Uno,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Var_FechaBatch = Fecha_Vacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN
			-- OBTENIENDO LAS APORTACIONES ANCLADAS
			TRUNCATE TABLE TMPAPORTANCLADAS;
			INSERT INTO TMPAPORTANCLADAS
				SELECT  anc.AportacionOriID,  SUM(tmp.Monto), SUM(tmp.InteresRecibir)
					FROM 	APORTANCLAJE anc
							INNER JOIN TMPAPORTACIONES tmp ON anc.AportacionAncID = tmp.AportacionID
					GROUP BY anc.AportacionOriID;

			-- ACTUALIZANDO EL MONTO A REINVERTIR DE LAS APORTACIONES ANCLADAS
			UPDATE TMPAPORTACIONES Tem, TMPAPORTANCLADAS Anc SET
						Tem.MontoReinvertir =   Tem.MontoReinvertir  +
										CASE WHEN (Tem.Reinvertir = Var_Capital)        THEN Anc.Monto
											 WHEN (Tem.Reinvertir = Var_CapitalInteres) THEN (Anc.Monto + Anc.InteresRecibir)
										END
				WHERE 	Tem.AportacionID	= Anc.AportacionID;

			-- VERIFICANDO SI HAY APORTACIONES ANCLADAS EN LA TABLA TEMPORAL
			SELECT  COUNT(AportacionID) INTO  Var_NumAports FROM   TMPAPORTANCLADAS;

			-- MANDAMOS A PAGAR LAS APORTACIONES ANCLADAS
			IF(Var_NumAports > Entero_Cero) THEN
				CALL APORTPAGOCIEPRO(
					Par_Fecha,          ProcesoCierre,      Pago_SIReinversion,     SalidaNO,       Par_NumErr,
					Par_ErrMen,         Var_ContadorTotal,  Var_ContadorExito,      Par_EmpresaID,  Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);
				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- BORRAMOS LAS APORTACIONES HIJAS QUE PERTENECEN AL ANCLAJE
			DELETE Tem
				FROM 	TMPAPORTACIONES Tem
				WHERE 	Tem.AportacionID IN (SELECT AportacionAncID
										FROM TMPAPORTANCLADAS Ant,
											  APORTANCLAJE Cla
										WHERE Ant.AportacionID = Cla.AportacionOriID);
			-- SE BORRA LA TABLA TEMPORAL
			TRUNCATE TABLE TMPAPORTANCLADAS;

			IF(Par_NumErr = Entero_Cero) THEN
				SET Par_NumErr      :=  Entero_Cero;
				SET Par_ErrMen      :=  'Ajuste Aportaciones Ancladas Realizados Exitosamente.';
			END IF;

			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual := NOW();

			/*Programa vencimiento masivo de aportaciones */
			IF(Aud_ProgramaID!=ProgramaVencMasivo)THEN
				CALL BITACORABATCHALT(
					ProcesoAport,        Par_Fecha,          Var_MinutosBit,    	Par_EmpresaID,      Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, 	Aud_Sucursal,       Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco   := NOW();
		END IF;

		SET Par_NumErr      :=  Entero_Cero;
		SET Par_ErrMen      :=  'Ajuste Aportaciones Ancladas Realizados Exitosamente.';

	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen;
	END IF;
END TerminaStore$$