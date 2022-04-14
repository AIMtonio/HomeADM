-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEDETECPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEDETECPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDOPEDETECPRO`(

	Par_FechaCarga		DATETIME,
    Par_Salida    		CHAR(1),
    INOUT Par_NumErr 	INT,
    INOUT Par_ErrMen	VARCHAR(400),

    Aud_EmpresaID 		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),

	Aud_NumTransaccion	BIGINT(20)
			)

TerminaStore: BEGIN


	DECLARE	Var_FecActual			DATETIME;
	DECLARE	Var_Empresa				INT;
	DECLARE	Var_MinutosBit			INT;
	DECLARE	Var_FecBitaco			DATETIME;
	DECLARE Var_Mensaje				VARCHAR(150);
	DECLARE Var_DetecOpeRelevante	CHAR(1);
	DECLARE Var_DetecOpeInusual		CHAR(1);
	DECLARE Var_EjecutaDetecOpeInusual	VARCHAR(200);

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Var_ProDetec		INT;
	DECLARE	Var_ProReele		INT;
	DECLARE	Var_ProInusu		INT;
	DECLARE	SalidaNO			CHAR(1);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	SoloFecha			DATE;
	DECLARE Si_EjecutaProceso	CHAR(1);
    DECLARE Var_Control			CHAR(30);
	DECLARE	EjecutaOpInu_Cierre	CHAR(1);


	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Var_ProDetec			:= 500;
	SET	Var_ProReele			:= 501;
	SET	Var_ProInusu			:= 502;

	SET	SoloFecha				:= DATE(Par_FechaCarga);
	SET Si_EjecutaProceso		:='S';
	SET SalidaNO				:='N';
	SET SalidaSI				:='S';
	SET EjecutaOpInu_Cierre		:= 'C';

	SET	Var_FecBitaco		:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEDETECPRO');
				SET Var_Control = 'SQLEXCEPTION' ;
		END;

        -- Parametro para ejecutar proceso de deteccion de operaciones inusuales en el cierre de dia o al momento de la transaccion
        SET Var_EjecutaDetecOpeInusual := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'EjecutaDetecOpeInusual');
		SET Var_EjecutaDetecOpeInusual := IFNULL(Var_EjecutaDetecOpeInusual,Cadena_Vacia);

		SELECT	Par_FechaCarga,		EmpresaDefault,		DetecOpeRelevante,			DetecOpeInusual
		INTO	Var_FecActual,		Var_Empresa,		Var_DetecOpeRelevante,		Var_DetecOpeInusual
			FROM PARAMETROSSIS;

		SET Aud_FechaActual:=NOW();

		SET	Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(
			Var_ProDetec,		Var_FecActual,		Var_MinutosBit,	Var_Empresa,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);


		IF(IFNULL(Var_DetecOpeRelevante,Cadena_Vacia) = Si_EjecutaProceso AND Var_EjecutaDetecOpeInusual = EjecutaOpInu_Cierre) THEN
			SET	Var_FecBitaco := NOW();

			SET	Aud_FechaActual := NOW();

			CALL PLDOPEREELEVANPRO(
				Par_FechaCarga,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := NOW();

			SET	Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
				Var_ProReele,		Var_FecActual,		Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		END IF;


		IF(IFNULL(Var_DetecOpeInusual,Cadena_Vacia) = Si_EjecutaProceso AND Var_EjecutaDetecOpeInusual = EjecutaOpInu_Cierre) THEN
			SET	Var_FecBitaco := NOW();

			SET	Aud_FechaActual := NOW();
			CALL PLDOPEINUSALERTPRO(
				Var_FecActual,			SalidaNO,			Par_NumErr,			Par_ErrMen,		Var_Empresa,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := NOW();

			SET	Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Aud_FechaActual, NOW());

			CALL BITACORABATCHALT(
				Var_ProInusu,		Var_FecActual,		Var_MinutosBit,		Var_Empresa,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		IF(((IFNULL(Var_DetecOpeRelevante,Cadena_Vacia) = Si_EjecutaProceso) OR (IFNULL(Var_DetecOpeInusual,Cadena_Vacia) = Si_EjecutaProceso)) AND Var_EjecutaDetecOpeInusual = EjecutaOpInu_Cierre) THEN

			CALL PLDENVIOCORREOPRO(
				SoloFecha,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Var_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= 'Proceso de PLD Finalizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_FecBitaco AS Consecutivo;
	END IF;

END TerminaStore$$