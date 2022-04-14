
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIOMENORWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIOMENORWSALT`;


DELIMITER $$
CREATE PROCEDURE `SOCIOMENORWSALT`(
-- ------------------------------------------------------
-- SP PARA REGISTRAR A UN CLIENTE MENOR DESDE WEBSERVICE .
-- ------------------------------------------------------

    Par_SucursalOri			INT(11),     	-- Parametro sucursal de origen del cliente menor
    Par_PrimerNom       	VARCHAR(50),    -- Parametro primer nombre del cliente menor
    Par_SegundoNom      	VARCHAR(50),	-- Parametro segundo nombre del cliente menor
    Par_TercerNom       	VARCHAR(50),	-- Parametro tercer nombre del cliente menor

    Par_ApellidoPat     	VARCHAR(50),	-- Parametro apellido paterno del cliente menor
    Par_ApellidoMat     	VARCHAR(50),	-- Paramtro apellido materno del cliente menor
    Par_FechaNac        	VARCHAR(50),	-- Parametro fecha de nacimiento del cliente menor
    Par_LugarNac        	INT(11),		-- Parametro lugar de nacimiento del cliente menor
	Par_EstadoID        	INT(11),		-- ID del Estado, hace referencia al ID del catálogo de ESTADOSREPUB, se refiere al estado en el que nació el Cliente Menor

    Par_Nacion          	CHAR(1),		-- Nacionalidad del Cliente Menor “N”= Nacional “E”= Extranjero
    Par_PaisResi        	INT(11),		-- Pais de Residencia, hace referencia a tabla PAISES
    Par_Sexo            	CHAR(1),		-- Sexo, “M” = Masculino “F” = Femenino
    Par_CURP            	CHAR(18),		-- Parametro CURP del cliente menor
	Par_TelefonoCel     	VARCHAR(20),	-- Parametro telefono celular del cliente menor

    Par_Telefono        	VARCHAR(20),	-- Parametro telefono del cliente menor
	Par_Correo          	VARCHAR(50),	-- Parametro correo electronico del cliente menor

	Par_PromotorIni     	INT(11),		-- Parametro promotor inicial del cliente menor
    Par_PromotorActual  	INT(11),		-- Parametro promotor actual del cliente menor

	Par_ClienteTutorID   	INT(11),		-- Parametro cliente tutor del cliente menor
    Par_NombreTutor     	VARCHAR(150),	-- Parametro nombre del tutor del cliente menor
    Par_MotivoApert     	CHAR(1),		-- Motivo de Apertura Razon del alta del cliente Credito 2.- Recomendado 3.- Publicidad  Campaña Promocion 4.- Necesidad/ Proveedor 5.- Cercania de Sucursal\n6.- Cuenta de Captacion
    Par_Salida    			CHAR(1), 		-- Parametro indica si la respuesta debe mostrarse S = SI N = NO

    INOUT	Par_NumErr 		INT(11),		-- Parametro de salida Numero de error
    INOUT	Par_ErrMen  	VARCHAR(350),	-- Parametro de salida Mensaje de error

	Aud_EmpresaID       	INT(11),		-- Auditoria
    Aud_Usuario         	INT(11),		-- Auditoria
    Aud_FechaActual     	DATETIME,       -- Auditoria
    Aud_DireccionIP     	VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      	VARCHAR(50),    -- Auditoria
    Aud_Sucursal        	INT(11),        -- Auditoria
    Aud_NumTransaccion  	BIGINT(20)      -- Auditoria
)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Cadena_Vacia		CHAR(1);			-- Constante Cadena vacia
DECLARE	Decimal_Cero		DECIMAL(12,2);		-- Constante Decimal cero
DECLARE	Entero_Cero			INT(11);	        -- Constante entero cero
DECLARE	RiesgoBajo			CHAR(1);            -- Constante riesgo bajo
DECLARE	TipoPerFisica		CHAR(1);	        -- Constante  tipo de persona fisica F
DECLARE	EdoCivilSol			CHAR(2);			-- Estado civil sol

-- Declaracion de variables
DECLARE	Var_SI				CHAR(1);            -- variable variable si
DECLARE	Var_NO				CHAR(1);            -- variable variable no
DECLARE	Var_Titulo			CHAR(1);			-- Variable titulo del cliente
DECLARE	Var_Clasific		CHAR(1);		    -- Variable clasificacion del cliente
DECLARE	Var_ActBancoMX		VARCHAR(15);	    -- Variable actividad de banco mx del cliente
DECLARE	Var_Ocupacion		INT(11);		    -- Variable	ocupacion del cliente
DECLARE	Var_SecGeneral		INT(11);		    -- Variable sector general del cliente
DECLARE	Var_ActINEGI		INT(11);                -- Variable actividad inegi del cliente
DECLARE Var_SecEconomic		INT(11);				-- Variable sector economico del cliente
DECLARE Var_ActFR			BIGINT(20);			-- Actividad Principal del Cte, segun la ACTIVIDADESFR
DECLARE Var_ClienteID			INT(11);			-- Contiene el cliente menor id
DECLARE Var_ActFOMUR		INT(11);		-- Actividad FOMUR

-- Asignacion de constantes
SET Cadena_Vacia		:="";
SET Entero_Cero			:=0;
SET Decimal_Cero		:=0.00;
SET TipoPerFisica		:="F";
SET EdoCivilSol			:="S";
SET Var_Titulo			:="C";
SET Var_Clasific		:="I";
SET RiesgoBajo			:="B";
-- Asignacion de variables
SET Var_SI				:="S";
SET Var_NO				:="N";
SET Var_Ocupacion		:= 42;
SET Var_SecGeneral		:= 999;
SET Var_ActBancoMX		:= "9999999999";
SET Var_ActINEGI		:= "99999";
SET Var_SecEconomic		:= "0";
SET Var_ActFR			:= "999999999999";
SET Var_ActFOMUR		:= "99999999";




CALL SOCIOMENORALT(
    Par_SucursalOri,		TipoPerFisica,		Var_Titulo,			Par_PrimerNom,		Par_SegundoNom,
	Par_TercerNom,			Par_ApellidoPat,	Par_ApellidoMat,	Par_FechaNac,		Par_LugarNac,
	Par_EstadoID, 			Par_Nacion,			Par_PaisResi,		Par_Sexo,			Par_CURP,
	Cadena_Vacia,			EdoCivilSol,		Par_TelefonoCel,	Par_Telefono,		Par_Correo,
	Cadena_Vacia,			Entero_Cero,		Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,
    Var_Ocupacion,			Cadena_Vacia,		Cadena_Vacia,		Decimal_Cero,		Cadena_Vacia,
	Var_Clasific,			Par_MotivoApert,		Var_NO,				Var_NO,				Var_SI,
	RiesgoBajo,				Var_SecGeneral,		Var_ActBancoMX,		Var_ActINEGI,		Var_SecEconomic,
	Var_ActFR, 				Var_ActFOMUR,		Par_PromotorIni,	Par_PromotorActual,	Entero_Cero,
	Var_SI,					Par_ClienteTutorID,	Par_NombreTutor,	Entero_Cero,		Cadena_Vacia,
	Entero_Cero,			Entero_Cero,		Aud_EmpresaID,		Par_Salida,			Par_NumErr,
    Par_ErrMen,				Var_ClienteID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
    Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion  );

END TerminaStore$$
