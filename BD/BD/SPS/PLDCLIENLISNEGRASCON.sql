-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCLIENLISNEGRASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCLIENLISNEGRASCON`;
DELIMITER $$


CREATE PROCEDURE `PLDCLIENLISNEGRASCON`(
/* SP DE CONSULTA EN LISTAS NEGRAS Y ENCUENTRA RELACIONES CON EL CLIENTE */
	Par_PersonaLisNeg	INT(11),			-- ID de la persona a consultar: Cliente o Usuario de Serv. o PersonaBloqueada
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta
	/* Parámetros de Auditoría */
	Par_EmpresaID 		INT(11) ,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Entero_Cero			INT;
DECLARE	ConsultaPrincipal	INT;
DECLARE SiListNeg			CHAR(1);
DECLARE NoListNeg			CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Mexico				INT;
DECLARE CatProcIntID		VARCHAR(10);
DECLARE	CatMotivInusualID	VARCHAR(15);
DECLARE	DescripOpera		VARCHAR(52);
DECLARE	Decimal_Cero		DECIMAL;
DECLARE	ClaveRegistra		CHAR(2);
DECLARE	RegistraSAFI		CHAR(4);
DECLARE	Str_No				CHAR(1);
DECLARE	Str_Si				CHAR(1);
DECLARE Par_NumErr			INT;
DECLARE Par_ErrMen			VARCHAR(400);

-- Declaracion de variables
DECLARE Var_ClienteID 			INT(11);
DECLARE Var_UsuarioServicioID 	INT(11);
DECLARE Var_SoloNombres			varchar(150);
DECLARE	Par_PrimerNombre		VARCHAR(50);
DECLARE	Par_SegundoNombre		VARCHAR(50);
DECLARE	Par_TercerNombre		VARCHAR(50);
DECLARE	Par_ApellidoPaterno		VARCHAR(50);
DECLARE	Par_ApellidoMaterno		VARCHAR(50);
DECLARE	Par_NombreCompleto		VARCHAR(200);
DECLARE	Par_RFC					CHAR(13);
DECLARE	Par_FechaNacimiento		DATE;
DECLARE	Par_PaisID				INT(11);
DECLARE	Par_EstadoID			INT(11);
DECLARE Coincidencia 			INT;
DECLARE Var_FechaDeteccion		DATE;
DECLARE Par_ClavePersonaInv		INT;
DECLARE Var_OpeInusualID		BIGINT(20);
DECLARE Var_TipoPersSAFI		VARCHAR(3);
DECLARE Par_TipoPersona			CHAR(1);
DECLARE Var_PersonaBloqID		BIGINT(12);		-- Persona bloqueada id

-- Asignacion de Constantes
SET Cadena_Vacia 		:='';			-- Cadena Vacia
SET	Entero_Cero			:= 0;			-- Entero Cero
SET Decimal_Cero		:= 0.0;			-- Decimal Cero
SET	ConsultaPrincipal	:= 2;			-- Consulta Principal
SET Coincidencia 		:= 0;			-- No. Coincidencia
SET SiListNeg			:='S';			-- Si esta bloqueado
SET NoListNeg			:='N';			-- No esta bloqueado
SET Mexico				:=700;			-- Codigo de pai­s de mexico

SET	CatProcIntID		:='PR-SIS-000';		-- Clave interna
SET	CatMotivInusualID	:='LISNEG';			-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
SET	DescripOpera		:='LISTA NEGRA';	-- Comentario en operaciones de alta o modificacion de clientes
SET	ClaveRegistra		:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET	RegistraSAFI		:= 'SAFI';
SET	Str_No				:= 'N';
SET	Str_Si				:= 'S';
SET	Par_NumErr			:= 0;
SET	Par_ErrMen			:= '';
SET Var_TipoPersSAFI 	:= 'CTE';		-- La persona es Cliente

-- Consulta que detecta a personas en lista de bloqueados usada en ventanilla, desembolso credito,
--  apertura de cuenta, inversion, cuentas de ahorro y cedes
IF(Par_NumCon = ConsultaPrincipal) THEN

	IF(IFNULL(Aud_NumTransaccion,Entero_Cero)=Entero_Cero)THEN
		CALL TRANSACCIONESPRO(Aud_NumTransaccion);
	END IF;

	SET Var_ClienteID := Par_PersonaLisNeg;

    SELECT
		PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
        RFC,				FechaNacimiento,	PaisResidencia,		EstadoID,				NombreCompleto,
		TipoPersona
	INTO
		Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
		Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
		Par_TipoPersona
        FROM CLIENTES
			WHERE ClienteID = Var_ClienteID;

	CALL PLDDETECLISNEGPRO(
		Var_ClienteID,			Par_PrimerNombre,	Par_SegundoNombre,		Par_TercerNombre,		Par_ApellidoPaterno,
		Par_ApellidoMaterno,	Par_RFC,			Par_FechaNacimiento,	Cadena_Vacia,			Entero_Cero,
        Par_PaisID,				Par_EstadoID,		Entero_Cero,			Str_Si,					Var_TipoPersSAFI,
        Par_TipoPersona,		Str_No,				Par_NumErr,				Par_ErrMen,				Var_PersonaBloqID,
        Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero) THEN
		SELECT SiListNeg AS EsListaNegra, Entero_Cero AS Coincidencia;
	ELSE
		SELECT NoListNeg AS EsListaNegra, Entero_Cero AS Coincidencia;
	END IF;

END IF;

END TerminaStore$$
