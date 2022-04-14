-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSFAMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSFAMLIS`;DELIMITER $$

CREATE PROCEDURE `GRUPOSFAMLIS`(
/* LISTA LOS INTEGRANTES DE UN GRUPO FAMILIAR */
	Par_ClienteID				BIGINT(12),		-- ID del Cliente a quien le pertenece el grupo.
	Par_TipoLista				TINYINT,		-- Tipo de Lista
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
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);
DECLARE ListaPrincipal	INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET ListaPrincipal		:= 1;				-- Núm. de lista principal
SET Aud_FechaActual 	:= NOW();

IF(IFNULL(Par_TipoLista, Entero_Cero)=ListaPrincipal)THEN
	SELECT
		LPAD(GF.FamClienteID,10,0)FamClienteID,UPPER(C.NombreCompleto)AS NombreCompleto,GF.TipoRelacionID,T.Descripcion
	FROM GRUPOSFAM GF
		INNER JOIN CLIENTES C ON (GF.FamClienteID=C.ClienteID)
		INNER JOIN TIPORELACIONES T ON (GF.TipoRelacionID=T.TipoRelacionID)
		WHERE GF.ClienteID = Par_ClienteID;
END IF;

END TerminaStore$$