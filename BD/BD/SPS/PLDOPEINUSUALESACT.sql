-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESACT`;DELIMITER $$

CREATE PROCEDURE `PLDOPEINUSUALESACT`(
/* SP DE ACTUALIZACION PARA OPERACIONES INUSUALES */
	Par_OpeInusualID				INT(11),
	Par_Estatus						CHAR(1),
	Par_ComentarioOC				VARCHAR(1500),
	Par_ClavePersonaInv				INT(11),
	Par_NomPersonaInv				VARCHAR(100),

	Par_Var_SucOrigen				INT(11),
	Par_TipoActulizacion			INT(11),
	Par_FolioInterno				INT(11),
	Par_Salida						CHAR(1),
	INOUT Par_NumErr				INT(11),

	INOUT Par_ErrMen				VARCHAR(400),
    /* Parametros de Auditoria */
	Par_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),

	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CompEstatus				INT(11);
DECLARE Var_SucOrigen				INT(11);
DECLARE	Var_FolioInterno			INT(11);
DECLARE	Var_FechaSistema			DATE;
DECLARE	Var_FolioSITI				VARCHAR(15);
DECLARE	Var_Control 				VARCHAR(20);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia				CHAR(1);
DECLARE	Fecha_Vacia					DATE;
DECLARE	Entero_Cero					INT(11);
DECLARE	Str_SI						CHAR(1);
DECLARE	EstatusCapturada			INT(11);
DECLARE	EstatusReportar				INT(11);
DECLARE	EstatusEnSeguimiento		INT(11);
DECLARE	EstatusNoReportar			INT(11);
DECLARE	Fecha_cierre				DATE;

DECLARE	Tipo_ActualizaPoGestion			INT(11);
DECLARE	Tipo_ActualizaQuitarFolioInt	INT(11);
DECLARE	Tipo_ActualizaGenerarReporte	INT(11);


-- Asignacion de Constantes
SET	Cadena_Vacia					:= '';				-- Cadena Vacia
SET	Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
SET	Entero_Cero						:= 0;				-- Entero Cero
SET	Str_SI							:= 'S';				-- Cadena de Si
SET	EstatusCapturada				:= 1;				-- Estatus de Operacion inusual detectada y capturada (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)
SET	EstatusEnSeguimiento			:= 2;				-- Estatus de Operacion inusual en seguimiento(investigacion)   (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)
SET	EstatusReportar					:= 3;				-- Estatus de Operacion inusual marcada como reportar a CNBV (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)
SET	EstatusNoReportar				:= 4;				-- Estatus de Operacion inusual marcada como no reportar a CNBV (1.- Capturada  2.- En Seguimiento  3.-Reportada  4.- No Reportada)

SET	Tipo_ActualizaPoGestion			:= 1;				-- Tipo de Actualizacion por pantalla de Gestion de Operaciones Inusuales
SET	Tipo_ActualizaQuitarFolioInt	:= 2;				-- Tipo de Actualizacion para la Generacion de Reporte (archivo) a la CNBV que quita el Folio Interno
SET	Tipo_ActualizaGenerarReporte	:= 3;				-- Tipo de Actualizacion para la Generacion de Reporte (archivo) a la CNBV que asigna el Folio Interno a las operaciones marcadas para enviarse en el archivo

-- Inicializa variables de Salida
SET	Par_NumErr		:= 1;
SET	Par_ErrMen		:= Cadena_Vacia;

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEINUSUALESACT');
		SET Var_Control:= 'sqlException';
    END;

	SET Var_FechaSistema	:=(SELECT FechaSistema FROM PARAMETROSSIS);

	--  1.-Tipo de Actualizacion por pantalla de Gestion de Operaciones Inusuales
	IF Par_TipoActulizacion = Tipo_ActualizaPoGestion THEN
		IF(NOT EXISTS(SELECT OpeInusualID
					FROM PLDOPEINUSUALES
					WHERE OpeInusualID = Par_OpeInusualID)) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('El Numero Operacion No Existe.');
			SET Var_Control:= 'opeInusualID';
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus, FolioInterno
		INTO Var_CompEstatus,	Var_FolioInterno
		FROM PLDOPEINUSUALES
		WHERE OpeInusualID=Par_OpeInusualID;

		SET Var_FolioInterno	:= IFNULL(Var_FolioInterno, Entero_Cero);

		SET Var_SucOrigen	 	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID=Par_ClavePersonaInv);

		IF (Var_CompEstatus=EstatusReportar)THEN
			UPDATE PLDOPEINUSUALES
			SET	Estatus 			= Par_Estatus,
				ComentarioOC 		= Par_ComentarioOC
			WHERE OpeInusualID= Par_OpeInusualID;
		ELSE
			UPDATE PLDOPEINUSUALES
			SET		Estatus 		= Par_Estatus,
					ComentarioOC 	= Par_ComentarioOC,
					ClavePersonaInv	= Par_ClavePersonaInv,
					NomPersonaInv	= Par_NomPersonaInv,
					SucursalID		= Var_SucOrigen
			WHERE OpeInusualID= Par_OpeInusualID;
		END IF;

		SET Fecha_Cierre := (SELECT FechaSistema FROM PARAMETROSSIS);

		IF (Par_Estatus= EstatusReportar OR Par_Estatus = EstatusNoReportar	)THEN
			UPDATE PLDOPEINUSUALES
			SET FechaCierre= Fecha_Cierre
			WHERE OpeInusualID=Par_OpeInusualID;
		END IF;

		IF (Par_Estatus= EstatusCapturada OR Par_Estatus = EstatusEnSeguimiento) THEN
			UPDATE PLDOPEINUSUALES
			SET FechaCierre= Fecha_Vacia
			WHERE OpeInusualID=Par_OpeInusualID;
		END IF;

		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= CONCAT( 'Operacion Inusual Actualizada Exitosamente: ', Par_OpeInusualID, '.');
        SET Var_Control := 'opeInusualID';
		LEAVE ManejoErrores;
	END IF;



	--  2.-Tipo de Actualizacion para la Generacion de Reporte (archivo) a la CNBV que quita el Folio Interno a las operaciones marcadas que se deben reportar
	IF Par_TipoActulizacion = Tipo_ActualizaQuitarFolioInt THEN

		UPDATE PLDOPEINUSUALES
		SET FolioInterno = Entero_Cero
		WHERE Estatus = EstatusReportar;

		SET	Par_NumErr	:= Entero_Cero;
		SET	Par_ErrMen	:= 'Folio Interno Eliminado con Exito.';
        SET Var_Control := 'opeInusualID';
		LEAVE ManejoErrores;

	END IF;


	--  3.- Tipo de Actualizacion para la Generacion de Reporte (archivo) a la CNBV que asigna el Folio Interno a las operaciones marcadas para enviarse en el archivo
	IF Par_TipoActulizacion = Tipo_ActualizaGenerarReporte  THEN
	SET	Var_FolioSITI		:= Cadena_Vacia;
	SET	Var_FechaSistema	:= IFNULL(Var_FechaSistema, Fecha_Vacia);
	SET	Var_FolioInterno	:= DATE_FORMAT(Var_FechaSistema,'%Y%m%d');


	SET	Var_FolioSITI		:= (SELECT MAX(FolioSITI) FROM PLDCNBVOPEINU WHERE FolioInterno = Var_FolioInterno);
	SET	Var_FolioSITI		:= IFNULL(Var_FolioSITI, Cadena_Vacia);

	IF NOT EXISTS (SELECT OpeInusualID FROM PLDOPEINUSUALES WHERE OpeInusualID = Par_OpeInusualID   AND Estatus = EstatusReportar) THEN
		SET	Par_NumErr	:= 2;
		SET	Par_ErrMen	:= CONCAT('La Operacion ', CAST(Par_OpeInusualID AS CHAR), ' No Existe en las Operaciones con Estatus a Reportar.');
        SET Var_Control := 'opeInusualID';
		LEAVE ManejoErrores;
	END IF;

	UPDATE PLDOPEINUSUALES
	SET FolioInterno = Var_FolioInterno
	WHERE	OpeInusualID = Par_OpeInusualID;

	SET	Par_NumErr	:= Entero_Cero;
	SET	Par_ErrMen	:= 'Reporte Generado con Exito con la(s) Operacion(es) Marcada(s).';
	SET Var_Control := 'opeInusualID';
	LEAVE ManejoErrores;

END IF;

END ManejoErrores;

IF(Par_Salida = Str_SI)THEN
	SELECT 	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$