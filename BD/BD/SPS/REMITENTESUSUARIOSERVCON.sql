-- SP REMITENTESUSUARIOSERVCON

DELIMITER ;

DROP PROCEDURE IF EXISTS `REMITENTESUSUARIOSERVCON`;

DELIMITER $$

CREATE PROCEDURE `REMITENTESUSUARIOSERVCON` (
-- =======================================================================
-- ----- STORE PARA LA CONSULTA DE REMITENTES DE USUARIO DE SERVICIO -----
-- =======================================================================
	Par_UsuarioServicioID	INT(11),			-- Numero de Usuario de Servicio
	Par_RemitenteID			BIGINT(12),			-- Numero de Remitente
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);		-- Entero Cero
    DECLARE Decimal_Cero	DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   	CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;			-- Fecha Vacia

	DECLARE Con_Remitentes	INT(11);		-- Consulta de Remitentes de Usuario de Servicio

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 			-- Entero Cero
    SET Decimal_Cero        := 0.00;		-- Decimal Cero
	SET Cadena_Vacia		:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia

	SET Con_Remitentes		:= 4;			-- Consulta de Remitentes de Usuario de Servicio

    -- 1.- Consulta Principal de Remitentes de Usuario de Servicio
	IF(Par_NumCon = Con_Remitentes)THEN
		SELECT  UsuarioServicioID,		Fecha,					RemitenteID,			Titulo,					TipoPersona,
				NombreCompleto,			FechaNacimiento,		PaisNacimiento,			EdoNacimiento,			EstadoCivil,
				Sexo,					CURP,					RFC,					FEA,					PaisFEA,
				OcupacionID,			Puesto,					SectorID,				ActividadBMXID,			ActividadINEGIID,
				SectorEcoID,			TipoIdentiID,			NumIdentific,			FecExIden,				FecVenIden,
				TelefonoCasa,			ExtTelefonoPart,		TelefonoCelular,		Correo,					Domicilio,
				Nacionalidad,			PaisResidencia
        FROM REMITENTESUSUARIOSERV
        WHERE UsuarioServicioID = Par_UsuarioServicioID
        AND RemitenteID = Par_RemitenteID;
    END IF;

END TerminaStore$$