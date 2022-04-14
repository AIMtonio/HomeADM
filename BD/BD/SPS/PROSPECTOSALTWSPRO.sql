
-- PROSPECTOSALTWSPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSALTWSPRO`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `PROSPECTOSALTWSPRO`(
	/*SP UTILIZADO PARA EL WS prospect microfinws/controlador/prospects*/

	Par_ProspectoIDExt		BIGINT(20),
	Par_PrimerNom 			VARCHAR(50),
	Par_SegundoNom 			VARCHAR(50),
	Par_TercerNom 			VARCHAR(50),
	Par_ApellidoPat	 		VARCHAR(50),

	Par_ApellidoMat	 		VARCHAR(50),
	Par_Telefono 			CHAR(13),
	Par_Calle 				VARCHAR(50),
	Par_NumExterior 		CHAR(10),
	Par_NumInterior 		CHAR(10),

	Par_Colonia				VARCHAR(200),
	Par_Manzana	 			VARCHAR(20),
	Par_Lote		 		VARCHAR(20),
	Par_LocalidadID			INT(11),
	Par_ColoniaID 			INT(11),

	Par_MunicipioID 		INT(11),
	Par_EstadoID 			INT(11),
	Par_CP 					VARCHAR(5),
	Par_TipoPersona 		CHAR(1),
	Par_RazonSocial 		VARCHAR(50),

	Par_FechaNacimiento		DATE,
	Par_RFC 				CHAR(13),
	Par_Sexo				CHAR(1),
	Par_EstadoCivil			CHAR(2),
	Par_Latitud 			VARCHAR(45),

	Par_Longitud			VARCHAR(45),
	Par_TipoDireccionID		INT,
	Par_OcupacionID			INT(5),
	Par_Puesto          	VARCHAR(100),
	Par_LugarTrabajo    	VARCHAR(100),

	Par_AntiguedadTra   	DECIMAL(12,2),
	Par_TelTrabajo      	VARCHAR(20),
	Par_Clasificacion   	CHAR(1),
	Par_NoEmpleado      	VARCHAR(20),
	Par_TipoEmpleado    	CHAR(1),

	Par_RFCpm            	CHAR(13),
	Par_ExtTelefonoPart		VARCHAR(6),
	Par_ExtTelefonoTrab		VARCHAR(6),
	Par_Nacion				CHAR(1),		-- Nacionalidad del aval N.- Nacional E.- Extranjero
	Par_LugarNacimiento		INT(11),		-- Pais de Nacimiento
	Par_PaisID				INT(11),		-- Pais de Residencia

	Par_Salida          	CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID        	INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal		  	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero		INT;
DECLARE Bigint_Cero		BIGINT(20);
DECLARE Fecha_Vacia		DATE;
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Per_Fisica		CHAR(1);
DECLARE	Per_ActEmp		CHAR(1);
DECLARE	Per_Moral		CHAR(1);
DECLARE Var_ProspectoID INT;
DECLARE Var_NombreComp	VARCHAR(200);
DECLARE Var_LocalidadID INT;
DECLARE Var_ColoniaID   INT;
DECLARE Valida_RFC		CHAR(13);
DECLARE Valida_IDExt	BIGINT(20);
DECLARE varControl		VARCHAR(100);
DECLARE varConsecutivo	VARCHAR(50);
DECLARE SalidaSI		CHAR(1);
DECLARE Salida_NO		CHAR(1);
DECLARE PaisMexico		INT(11);
DECLARE CalificPros		CHAR(1);
DECLARE Var_Control		VARCHAR(50);
DECLARE Cons_Si			CHAR(1);
DECLARE EsNA			CHAR(3);

-- Asignacion de Constantes
SET	Entero_Cero			:= 0;
SET	Bigint_Cero			:= 0;
SET	Fecha_Vacia    		:= '1900-01-01';
SET	Cadena_Vacia  		:= '';
SET	Per_Fisica	      	:= 'F';
SET	Per_ActEmp   		:= 'A';
SET	Per_Moral	      	:= 'M';
SET CalificPros			:= 'N';
SET SalidaSI			:= 'S';
SET Salida_NO			:= 'N';
SET	Var_ProspectoID 	:= 0;
SET	Valida_RFC			:= Cadena_Vacia;
SET	Valida_IDExt		:= 0;
SET varConsecutivo		:= 0;
SET PaisMexico			:= 700;				-- Pais Mexico
SET Cons_Si				:= 'S';

SET Par_PrimerNom		:= TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
SET Par_SegundoNom		:= TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
SET Par_TercerNom		:= TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
SET Par_ApellidoPat		:= TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
SET Par_ApellidoMat		:= TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));

SET Par_OcupacionID		:= IFNULL(Par_OcupacionID, Entero_Cero);
SET Par_Puesto			:= IFNULL(Par_Puesto, Cadena_Vacia);
SET Par_LugarTrabajo	:= IFNULL(Par_LugarTrabajo, Cadena_Vacia);
SET Par_AntiguedadTra	:= IFNULL(Par_AntiguedadTra, Entero_Cero);
SET Par_TelTrabajo		:= IFNULL(Par_TelTrabajo, Cadena_Vacia);
SET Par_Clasificacion	:= IFNULL(Par_Clasificacion, Cadena_Vacia);
SET Par_NoEmpleado		:= IFNULL(Par_NoEmpleado, Cadena_Vacia);
SET Par_TipoEmpleado 	:= IFNULL(Par_TipoEmpleado, Cadena_Vacia);
SET EsNA				:= 'NA';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PROSPECTOSALTWSPRO');
		SET varControl := 'sqlException' ;
	END;

	SET Var_ProspectoID:= (SELECT IFNULL(MAX(ProspectoID),Entero_Cero) + 1
							FROM PROSPECTOS);

	CALL PROSPECTOSALT (
		Par_ProspectoIDExt,		Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,		Par_ApellidoPat,
		Par_ApellidoMat,		Par_Telefono,			Par_Calle,				Par_NumExterior,	Par_NumInterior,
		Par_Colonia,			Par_Manzana,			Par_Lote,				Par_LocalidadID,	Par_ColoniaID,
		Par_MunicipioID,		Par_EstadoID,			Par_CP,					Par_TipoPersona,	Par_RazonSocial,
		Par_FechaNacimiento,	Par_RFC,				Par_Sexo,				Par_EstadoCivil,	Par_Latitud,
		Par_Longitud,			Par_TipoDireccionID,	Par_OcupacionID,		Par_Puesto,			Par_LugarTrabajo,
		Par_AntiguedadTra,		Par_TelTrabajo,			Par_Clasificacion,		Par_NoEmpleado,		Par_TipoEmpleado,
		Par_RFCpm,				Par_ExtTelefonoPart,	Par_ExtTelefonoTrab,	Par_Nacion,			Par_LugarNacimiento,
		Par_PaisID,				Par_Salida,				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion
	);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SET Var_ProspectoID := (SELECT ProspectoID FROM PROSPECTOS WHERE NumTransaccion = Aud_NumTransaccion LIMIT 1);
	SET Var_ProspectoID:= TRIM(REPLACE(Par_ErrMen,'Prospecto Agregado Exitosamente: ',''));

	SET Par_NumErr := 0;
    SET Par_ErrMen := Par_ErrMen;
	SET varControl := 'prospectoID';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            varControl AS Control,
            Var_ProspectoID AS Consecutivo;
END IF;

END TerminaStore$$