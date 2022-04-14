-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVEEDORESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVEEDORESCON`;DELIMITER $$

CREATE PROCEDURE `PROVEEDORESCON`(
	Par_ProveedorID		INT,
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

-- declaracion de Constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Con_Principal	INT;
DECLARE Con_Foranea		INT;
DECLARE Con_CuentaClabe	INT;

-- asignacion de Constantes
SET	Con_Principal		:= 1;
SET	Con_Foranea			:= 2;
SET	Con_CuentaClabe		:= 3;
SET Cadena_Vacia		:= "";


IF(Par_NumCon = Con_Principal) THEN
	SELECT	ProveedorID,		InstitucionID,
			IFNULL(PrimerNombre,Cadena_Vacia) AS PrimerNombre,
			IFNULL(SegundoNombre,Cadena_Vacia) AS SegundoNombre,
			IFNULL(ApellidoPaterno,Cadena_Vacia) AS ApellidoPaterno,
			IFNULL(ApellidoMaterno,Cadena_Vacia) AS ApellidoMaterno,
			TipoPersona,		FechaNacimiento,	CURP,				RazonSocial,		RFC,
			RFCpm,				TipoPago,			CuentaClave, 		CuentaCompleta,		CuentaAnticipo,
			TipoProveedor,  	Correo,			    Telefono,			TelefonoCelular,	Estatus,
			ExtTelefonoPart,	IFNULL(TipoTerceroID, Cadena_Vacia) AS TipoTerceroID,
			IFNULL(TipoOperacionID, Cadena_Vacia) AS TipoOperacionID,
            IFNULL(PaisID, Cadena_Vacia) AS PaisID,
            IFNULL(Nacionalidad, Cadena_Vacia) AS Nacionalidad,
            IFNULL(NumIDFiscal, Cadena_Vacia) AS NumIDFiscal,			PaisNacimiento,		EstadoNacimiento
	FROM 	PROVEEDORES
	WHERE	ProveedorID 	= Par_ProveedorID;
END IF;


IF(Par_NumCon = Con_CuentaClabe) THEN
	SELECT IFNULL(CuentaClave,Cadena_Vacia), TipoPago
		FROM PROVEEDORES WHERE ProveedorID = Par_ProveedorID;
END IF;

END TerminaStore$$