-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTANEGRASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDLISTANEGRASPRO`;DELIMITER $$

CREATE PROCEDURE `PLDLISTANEGRASPRO`(
/* SP DE PROCESO DE CARGA DE LISTAS NEGRAS*/
	Par_IncluyeEncabezado	CHAR(1),			-- Indica si incluye o  no el primer registro del archivo a cargar (Encabezado)
	Par_Salida				CHAR(1),			-- Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_ListaNegraID	BIGINT(12);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE Salida_SI 		CHAR(1);
	DECLARE Cons_Si			CHAR(1);
	DECLARE Cons_No			CHAR(1);
	DECLARE EstatusActivo	CHAR(1);
	DECLARE	PaisExtOt		INT(11);
	DECLARE PaisMexico		INT(11);
	DECLARE Mayusculas		CHAR(2);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Salida_SI		:= 'S';
	SET Cons_Si			:= 'S';
	SET Cons_No			:= 'N';
	SET EstatusActivo	:= 'A';				-- Estatus Activo
	SET PaisMexico		:= 700;				-- Corresponde al catalogo de PAISES: MEXICO (PAIS)
	SET PaisExtOt		:= 600;				-- Corresponde al catalogo de PAISES: EXTRANJERO, OTRO PAIS
	SET Mayusculas		:= 'MA';			-- Tipo de resultado en mayusculas

	SET Var_Control 		:= 'listaNegraID';
	SET Aud_FechaActual 	:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDLISTANEGRASPRO');
			SET Var_Control:= 'sqlException';
		END;
		# SE ELIMINAN LOS REGISTROS QUE NO FUERON POR PANTALLA Y CUYOS TIPOS DE LISTA NO SEAN PEP, SAT Y OFAC.
		DELETE FROM PLDLISTANEGRAS
		WHERE ProgramaID != '/microfin/listaNegrasVista.htm'
			AND TipoLista NOT IN ('SAT','PEP','OFAC');

		IF(Par_IncluyeEncabezado = Cons_Si) THEN
			DELETE FROM TMPCARGALISTASPLD WHERE IdListaNegraTemp = 1 OR Genero LIKE('%genero%');
		END IF;

		SET Var_ListaNegraID := (SELECT MAX(ListaNegraID) FROM PLDLISTANEGRAS);
		SET Var_ListaNegraID := IFNULL(Var_ListaNegraID, Entero_Cero);
		SET Aud_FechaActual := NOW();

		INSERT INTO PLDLISTANEGRAS (
			ListaNegraID,													PrimerNombre,
			SegundoNombre,													TercerNombre,
			ApellidoPaterno,												ApellidoMaterno,
			RFC,															CURP,
			FechaNacimiento,												NombreCompleto,
			NombresConocidos,												PaisID,
			EstadoID,														IDQEQ,
			SexoQeQ,														EstatusQeQ,
			FechaAlta,														Estatus,
			TipoLista,														RFCm,
			RazonSocial,													TipoPersona,
			SoloNombres,										            SoloApellidos,
			RazonSocialPLD,
			EmpresaID,															Usuario,
			FechaActual,														DireccionIP,
			ProgramaID,															Sucursal,
			NumTransaccion)
		SELECT
			(IdListaNegraTemp+Var_ListaNegraID),								IFNULL(LEFT(TRIM(UPPER(IF(Tmp.Nombre IS NULL,Razonsoc, Tmp.Nombre))),200),Cadena_Vacia),
			'',																	'',
			IFNULL(LEFT(TRIM(UPPER(Paterno)),100),Cadena_Vacia),				IFNULL(TRIM(UPPER(Tmp.Materno)),Cadena_Vacia),
			IFNULL(TRIM(UPPER(IF(Rfc IS NULL,Rfcmoral,Rfc))),Cadena_Vacia),		IFNULL(TRIM(UPPER(Curp)),Cadena_Vacia),
			FNFORMATOFECHA(LEFT(REPLACE(TRIM(Fecnac),'//','/'),10),''),			IF(LENGTH(Razonsoc) <= 1, FNGENNOMBRECOMPCARGALIS(TRIM(Tmp.Nombre),'','',LEFT(Tmp.Paterno,100),Tmp.Materno), Cadena_Vacia),
			IF(LENGTH(Razonsoc) <= 1,
				IFNULL(TRIM(UPPER(Nomcomp)),Cadena_Vacia), Cadena_Vacia),

			IF(LENGTH(IF(LENGTH(Rfc) <= 1, Rfcmoral,Rfc)) > 0, PaisMexico,
				IF((@EntidadFederativa:=FNOBTENEDOREPUB(Entidad))>Entero_Cero, PaisMexico,FNOBTENIDPAIS(Dependencia))),

			@EntidadFederativa,													FNLIMPIACARACTERESGEN(Idqeq,'OR'),
			IFNULL(TRIM(UPPER(Genero)),Cadena_Vacia),							IFNULL(TRIM(UPPER(Estatus)),Cadena_Vacia),
			Aud_FechaActual,													EstatusActivo,
			IFNULL(TRIM(UPPER(Lista)),Cadena_Vacia),							IFNULL(TRIM(UPPER(Rfcmoral)),Cadena_Vacia),
			IFNULL(LEFT(TRIM(UPPER(Razonsoc)),100),Cadena_Vacia),				IF(LENGTH(Razonsoc) <= 1, 'F','M'),
			FNGENNOMBRECOMPCARGALIS(TRIM(Tmp.Nombre),'','','',''),	            FNGENNOMBRECOMPCARGALIS('','','',LEFT(Tmp.Paterno,100),Tmp.Materno),
			IF(LENGTH(Razonsoc) <= 1, Cadena_Vacia,
				FNLIMPIACARACTERESGEN(LEFT(TRIM(Razonsoc),100),Mayusculas)),
			Aud_EmpresaID,														Aud_Usuario,
			Aud_FechaActual,													Aud_DireccionIP,
			Aud_ProgramaID,														Aud_Sucursal,
			Aud_NumTransaccion
			FROM
				TMPCARGALISTASPLD AS Tmp;

		-- SE DA DE ALTA EN EL HISTÓRICO LAS COINCIDENCIAS CON LOS CLIENTES, REALIZADAS DESDE PANTALLA Y DESDE LA CARGA MASIVA.
		CALL HISPLDDETECPERSALT(
			Cons_No, 			Par_NumErr, 		Par_ErrMen, 		Aud_EmpresaID, 		Aud_Usuario,
			Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID, 	Aud_Sucursal, 		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET	Par_NumErr := 0;
		SET	Par_ErrMen := CONCAT('Proceso de Carga de Listas Negras Exitoso.');
		SET Var_Control := 'incluyeEncabezado';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$