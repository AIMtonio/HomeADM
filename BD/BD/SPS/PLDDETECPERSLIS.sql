
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- PLDDETECPERSLIS

DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECPERSLIS`;

DELIMITER $$
CREATE PROCEDURE `PLDDETECPERSLIS`(
/* LISTA EL CATALOGO DE PAISES DE LA GAFI */
	Par_TipoLista				TINYINT,		-- TIPO DE LISTA.
	Par_TipoPersonaSAFI			VARCHAR(3),		-- Tipo de la persona involucrada
    /* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,

	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Tipo_DatosBusq	INT(11);
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Str_SI			CHAR(1);
DECLARE	Str_NO			CHAR(1);
DECLARE	Estatus_Activo	CHAR(1);
DECLARE	TipoPers_Fisica	CHAR(1);
DECLARE	TipoPers_Moral	CHAR(1);
DECLARE Es_Cliente		VARCHAR(3);
DECLARE Es_Usuario		VARCHAR(3);
DECLARE Es_Usuario2		VARCHAR(3);
DECLARE Es_Aval			VARCHAR(3);
DECLARE Es_Prospecto	VARCHAR(3);
DECLARE Es_Relacionado	VARCHAR(3);
DECLARE Es_Proveedor	VARCHAR(3);
DECLARE Es_ObligSol		VARCHAR(3);


-- Asignacion de Constantes
SET	Tipo_DatosBusq		:= 1; 				-- Tipo de lista principal.
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Str_SI				:= 'S';				-- Constante Si.
SET	Str_NO				:= 'N'; 			-- Constante No.
SET	Estatus_Activo		:= 'A'; 			-- Estatus Activo.
SET	TipoPers_Fisica		:= 'F'; 			-- Tipo de Persona Física.
SET	TipoPers_Moral		:= 'M'; 			-- Tipo de Persona Moral.
SET Es_Cliente			:= 'CTE';			-- Tipo de Persona Cliente.
SET Es_Usuario			:= 'USU';			-- Tipo de Persona Usuario de Serv.
SET Es_Usuario2			:= 'USU';			-- Tipo de Persona Usuario de Serv. 2.
SET Es_Aval				:= 'AVA';			-- Tipo de Persona Aval.
SET Es_Prospecto		:= 'PRO';			-- Tipo de Persona Prospecto.
SET Es_Relacionado		:= 'REL';			-- Tipo de Persona Relacionado a la cuenta.
SET Es_Proveedor		:= 'PRV';			-- Tipo de Persona Proveedor.
SET Es_ObligSol			:= 'OBS';			-- Tipo de Persona Obligado solidario.

IF(IFNULL(Par_TipoLista, Entero_Cero)) = Tipo_DatosBusq THEN
	DELETE FROM TMPPLDDETECPERS WHERE NumTransaccion = Aud_NumTransaccion;

	IF(Par_TipoPersonaSAFI IN (Es_Cliente,Cadena_Vacia))THEN
		INSERT INTO TMPPLDDETECPERS(
			TipoPersonaSAFI,		ClavePersonaInv,	NombreCompleto,			TipoPersona,			RFC,
			FechaNac,				PaisID,				EstadoID,				NumTransaccion)
		SELECT
			Es_Cliente,				CTE.ClienteID,
			IFNULL(REPLACE(IF(CTE.TipoPersona = TipoPers_Moral,CTE.RazonSocialPLD, CONCAT(CTE.SoloNombres,CTE.SoloApellidos)),' ',''),Cadena_Vacia),
			IF(CTE.TipoPersona = TipoPers_Moral, CTE.TipoPersona, TipoPers_Fisica) AS TipoPersona,
			CTE.RFCOficial,		CTE.FechaNacimiento,	CTE.LugarNacimiento,	CTE.EstadoID,
			Aud_NumTransaccion
		FROM CLIENTES CTE
		WHERE CTE.Estatus = Estatus_Activo;
	END IF;

	IF(Par_TipoPersonaSAFI IN (Es_Proveedor,Cadena_Vacia))THEN
		INSERT INTO TMPPLDDETECPERS(
			TipoPersonaSAFI,		ClavePersonaInv,	NombreCompleto,			TipoPersona,			RFC,
			FechaNac,				PaisID,				EstadoID,				NumTransaccion)
		SELECT
			Es_Proveedor,			PR.ProveedorID,
			IFNULL(REPLACE(IF(PR.TipoPersona = TipoPers_Moral,PR.RazonSocialPLD, CONCAT(PR.SoloNombres,PR.SoloApellidos)),' ',''),Cadena_Vacia),
			IF(PR.TipoPersona = TipoPers_Moral, PR.TipoPersona, TipoPers_Fisica) AS TipoPersona,
			IF(PR.TipoPersona = TipoPers_Moral, PR.RFCpm, PR.RFC),
			PR.FechaNacimiento,		IFNULL(PR.PaisNacimiento, Entero_Cero),	IFNULL(PR.EstadoNacimiento, Entero_Cero),
			Aud_NumTransaccion
		FROM PROVEEDORES PR
		WHERE PR.Estatus = Estatus_Activo;
	END IF;

	SELECT
		TipoPersonaSAFI,		ClavePersonaInv,	NombreCompleto,			TipoPersona,			RFC,
		FechaNac,				PaisID,				EstadoID
	FROM TMPPLDDETECPERS
	WHERE NumTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPPLDDETECPERS WHERE NumTransaccion = Aud_NumTransaccion;
END IF;


END TerminaStore$$

