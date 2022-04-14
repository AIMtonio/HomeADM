-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCALENDARIOINGRESOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISCALENDARIOINGRESOSALT`;
DELIMITER $$

CREATE PROCEDURE `HISCALENDARIOINGRESOSALT`(
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,	-- Numero de Convenio Nomina
    Par_Anio				INT(4),				-- Numero de Anio
    Par_Estatus				CHAR(1),			-- Estatus del Calendario de Ingresos R-Registrado, A-Autorizado y D-Desautorizado
	Par_FechaLimEnvio		DATE,				-- Fecha Limite Envio
    Par_FechaPrimerDesc		DATE,				-- Fecha Primer Descuento
	Par_FechaLimiteRecep	DATE,				-- Fecha Limite de recepcion de incidencias
    Par_NumCuotas			INT(11),			-- Número de Cuotas
	Par_UsuarioID			INT(11),			-- Número del Usuario que realiza la transaccion

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_FechaRegistro	DATE;			-- Fecha Registro de la transaccion
DECLARE Var_Control			VARCHAR(100);	-- Variable Control
DECLARE Hora_Actual         VARCHAR(11);	-- Hora Actual
-- DECLARACION DE CONSTANTES
DECLARE	Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
DECLARE	Fecha_Vacia			DATE;			-- Constante Fecha Vacia
DECLARE	Entero_Cero			INT;			-- Constante Entero Cero

DECLARE SalidaSI			CHAR(1);	-- Salida Si
DECLARE SalidaNO			CHAR(1);	-- Salida No

-- ASIGNACION DE CONSTANTES
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET SalidaSI        := 'S';

ManejoErrores:BEGIN


		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISCALENDARIOINGRESOSALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

        IF( IFNULL(Par_InstitNominaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de la Empresa Nomina se encuentra Vacio.';
			SET Var_Control	:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_ConvenioNominaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'El Numero de Convenio se encuentra vacio.';
			SET Var_Control	:= 'convenioNominaID';
			LEAVE ManejoErrores;
		END IF;


		IF( IFNULL(Par_Anio, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'El Año se encuentra vacio.';
			SET Var_Control	:= 'anio';
			LEAVE ManejoErrores;
		END IF;

        IF( IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El Estatus se encuentra Vacio.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

        SET Hora_Actual     := (SELECT DATE_FORMAT(NOW( ), "%H:%i:%S" ));
        SET Var_FechaRegistro := (SELECT  FechaSistema FROM PARAMETROSSIS);

		SET Aud_FechaActual := NOW();

		INSERT INTO HISCALENDARIOINGRESOS (
			InstitNominaID,		ConvenioNominaID,		Anio,				Estatus, 			FechaLimiteEnvio,
            FechaPrimerDesc,	FechaLimiteRecep,		NumCuotas,			FechaRegistro,		UsuarioID,
			Hora,	            EmpresaID,				Usuario,			FechaActual,		DireccionIP,
			ProgramaID,         Sucursal,				NumTransaccion)
		VALUES(
			Par_InstitNominaID,	Par_ConvenioNominaID,	Par_Anio,			Par_Estatus,		Par_FechaLimEnvio,
            Par_FechaPrimerDesc,Par_FechaLimiteRecep,	Par_NumCuotas,		Var_FechaRegistro,	Par_UsuarioID,
			Hora_Actual,        Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Historico del Calendario de Ingresos Registrado Correctamente.';
		SET Var_Control	:= 'calendarioIngID';

	END ManejoErrores;

-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Par_InstitNominaID		AS Consecutivo;

	END IF;


END TerminaStore$$
