-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESPRO`;DELIMITER $$

CREATE PROCEDURE `CLIENTESPRO`(
	Par_SucursalOri		INT,
	Par_TipoPersona		CHAR(1),
	Par_Titulo			VARCHAR(10),
	Par_PrimerNom		VARCHAR(50),
	Par_SegundoNom		VARCHAR(50),

	Par_TercerNom		VARCHAR(50),
	Par_ApellidoPat		VARCHAR(50),
	Par_ApellidoMat		VARCHAR(50),
	Par_FechaNac		VARCHAR(50),
	Par_LugarNac		VARCHAR(100),

	Par_estadoID	 	INT,
	Par_Nacion			CHAR(1),
	Par_PaisResi 		INT,
	Par_Sexo 			CHAR(1),
	Par_CURP			CHAR(17),

	Par_RFC				CHAR(13),
	Par_EstadoCivil 	CHAR(2),
	Par_TelefonoCel		VARCHAR(20) ,
	Par_Telefono 		VARCHAR(20) ,
	Par_Correo			VARCHAR(50),

	Par_RazonSocial		VARCHAR(150),
	Par_TipoSocID		INT,
	Par_RFCpm			CHAR(13),
	Par_GrupoEmp	  	INT,
	Par_Fax 			VARCHAR(20),

	Par_OcupacionID 	INT,
	Par_Puesto 			VARCHAR(100),
	Par_LugardeTrab		VARCHAR(100),
	Par_AntTra 			float,
	Par_TelTrabajo 		VARCHAR(20),

	Par_Clasific	 	CHAR(1),
	Par_MotivoApert		CHAR(1),
	Par_PagaISR 		CHAR(1),
	Par_PagaIVA 		CHAR(1),
	Par_PagaIDE 		CHAR(1),

	Par_NivelRiesgo 	CHAR(1),
	Par_SecGeneral		INT,
	Par_ActBancoMX		VARCHAR(15),
	Par_ActINEGI		INT,
	Par_SecEconomic		INT,

	Par_PromotorIni		INT,
	Par_PromotorActual 	INT,
	Par_NomConyuge 		VARCHAR(150),
	Par_RFCConyuge 		VARCHAR(13),

	Par_Salida 			CHAR(1),
	Par_ProspectoID		BIGINT(20),

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT;
DECLARE	Decimal_Cero	DECIMAL(12,2);
DECLARE	Fecha_Vacia		date;
DECLARE	Salida_NO 		CHAR(1);
DECLARE	Salida_SI 		CHAR(1);



DECLARE	Var_ClienteID	INT;
DECLARE	ErrMen			VARCHAR(30);
DECLARE	NumErr			INT;


SET Salida_SI 			:= 'S';
SET Entero_Cero			:= 0;
SEt Cadena_Vacia		:= '';

	-- Modificacion de llamado a alta de clientes para incluir un nuevo parametro de entrada. Cardinal Sistemas Inteligentes
	CALL CLIENTESALT(
		Par_SucursalOri,	Par_TipoPersona,	Par_Titulo,			Par_PrimerNom,	Par_SegundoNom,
		Par_TercerNom,		Par_ApellidoPat,	Par_ApellidoMat,	Par_FechaNac,	Par_LugarNac,
		Par_estadoID,		Par_Nacion,			Par_PaisResi,		Par_Sexo,		Par_CURP,
		Par_RFC,			Par_EstadoCivil,	Par_TelefonoCel,	Par_Telefono,	Par_Correo,
		Par_RazonSocial,	Par_TipoSocID,		Par_RFCpm,			Par_GrupoEmp,	Par_Fax,
		Par_OcupacionID,	Par_Puesto,			Par_LugardeTrab,	Par_AntTra,		Cadena_Vacia,
		Par_TelTrabajo,		Par_Clasific,		Par_MotivoApert,	Par_PagaISR,	Par_PagaIVA,
		Par_PagaIDE,		Par_NivelRiesgo,	Par_SecGeneral,		Par_ActBancoMX,	Par_ActINEGI,
		Par_SecEconomic,	Par_PromotorIni,	Par_PromotorActual,	Par_NomConyuge,	Par_RFCConyuge,
		Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,		Fecha_Vacia,	Aud_EmpresaID,
		Salida_SI,			Var_ClienteID,		NumErr,				ErrMen,			Entero_Cero,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion
	);
	-- Fin de modificacion a llamado de alta de clientes. Cardinal Sistemas Inteligentes

IF((ifnull(Aud_ProgramaID, Cadena_Vacia)) = "clientes.ws.altaCliente" )then
	call PROSPECTOSACT(
    Par_ProspectoID,    Var_ClienteID,      Salida_NO,      Aud_EmpresaID,  Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion,
    NumErr,				ErrMen);
END IF;


END TerminaStore$$