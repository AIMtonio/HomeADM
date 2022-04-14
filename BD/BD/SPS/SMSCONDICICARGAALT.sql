-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCONDICICARGAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCONDICICARGAALT`;DELIMITER $$

CREATE PROCEDURE `SMSCONDICICARGAALT`(
# =====================================================================================
# ----- STORE QUE REALIZA ALTA DE ARCHIVO  CSV PARA ENVIO MASIVO DE SMS ------
# =====================================================================================
	Par_CampaniaID		INT(11),
	Par_TipoEnvio		CHAR(1),
	Par_OpcEnvio	  	INT(11),
	Par_NumVeces 		INT(11),
	Par_Distancia  		CHAR(5),

	Par_FechaInicio		DATETIME,
	Par_FechaFin		DATETIME,
	Par_Periodicid		CHAR(1),
	Par_HoraPeriod		CHAR(5),
	Par_NumTransac		BIGINT(20),
	Par_FechaProgEn		DATETIME,

	Par_Salida			CHAR(1),
	INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN

    -- DEclaracion de variables
	DECLARE  Var_Control		VARCHAR(100);
	DECLARE Consecutivo    		VARCHAR(100);

	-- Declaracion de constantes
	DECLARE  Entero_Cero		INT(11);
    DECLARE  Entero_Uno			INT(11);
	DECLARE  SalidaSI			CHAR(1);
	DECLARE  SalidaNO			CHAR(1);
	DECLARE  Cadena_Vacia		CHAR(1);
	DECLARE  VarCargaID			INT(11);
	DECLARE  OpcAhora			INT(11);
	-- Asignacion de constantes
	SET	Entero_Cero		:= 0;
    SET Entero_Uno		:= 1;
	SET SalidaSI		:= 'S';
	SET SalidaNO		:= 'N';
	SET	Cadena_Vacia	:= '';
	SET OpcAhora 		:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						  'Disculpe las molestias que esto le ocasiona. Ref: SP-SMSCONDICICARGAALT');
				SET Var_Control = 'SQLEXCEPTION';
		END;

		SET VarCargaID := (SELECT IFNULL(MAX(ArchivoCargaID),Entero_Cero)+ Entero_Uno FROM SMSCONDICICARGA);

		IF(IFNULL(Par_OpcEnvio,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'La Opcion de Envio No Esta Seleccionado.';
			SET Var_Control := 'opcEnvio';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_OpcEnvio = OpcAhora )THEN
			SET Par_FechaProgEn := CURRENT_TIMESTAMP();
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		CALL SMSCALENDARIOACT(VarCargaID, Par_NumTransac);

		INSERT INTO SMSCONDICICARGA (
			ArchivoCargaID,		CampaniaID,			TipoEnvio,		OpcionEnvio,	NumVeces,
			Distancia,			FechaInicio,		FechaFin,		Periodicidad, 	HoraPeriodicidad,
			FechaProgEnvio, 	EmpresaID,			Usuario,			FechaActual,	DireccionIP,
			ProgramaID, 		Sucursal,			NumTransaccion)
		VALUES(
			VarCargaID,			Par_CampaniaID,		Par_TipoEnvio,		Par_OpcEnvio,		Par_NumVeces,
			Par_Distancia,		Par_FechaInicio,	Par_FechaFin,		Par_Periodicid,		Par_HoraPeriod,
			Par_FechaProgEn,	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr 	:= 000;
        SET Par_ErrMen 	:= 'Operacion Realizada Exitosamente';
        SET Var_Control	:= 'campaniaID';
		SET Consecutivo := Par_CampaniaID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr AS NumErr ,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$