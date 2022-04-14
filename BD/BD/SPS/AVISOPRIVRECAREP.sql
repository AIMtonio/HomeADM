-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVISOPRIVRECAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVISOPRIVRECAREP`;DELIMITER $$

CREATE PROCEDURE `AVISOPRIVRECAREP`(
	/* *** STORE DE REPORTE PARA AVISO DE PRIVACIDAD RECA *** */
	Par_CuentaAhoID 		BIGINT(12),	-- Numero de la Cuenta de Ahorro
    Par_NumCon		 		TINYINT(1),	-- Numero de la Consulta
	/* Parametros de Auditoria */
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),

	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Con_AvisoPriv			INT;
	DECLARE	Con_DispoLegal			INT;

	-- Declaracion de Variables
	DECLARE Var_Reca	 			VARCHAR(100); -- numero de Registro reca
	DECLARE Var_NomCliente	 		VARCHAR(250); -- nombre completo del cliente
	DECLARE Var_Ejecutivo			VARCHAR(250); -- nombre completo del ejecutivo

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';	-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';-- Fecha Vacia
	SET	Entero_Cero				:= 0;	-- Entero Cero
	SET Con_AvisoPriv			:= 1; -- Consulta para aviso de privacidad de registro reca
	SET Con_DispoLegal			:= 2; -- Consulta para disposiciones legales

	IF(Par_NumCon=Con_AvisoPriv)THEN
		SELECT usu.NombreCompleto
			INTO Var_Ejecutivo
			FROM CUENTASAHO ctas,
				USUARIOS usu
			WHERE ctas.UsuarioApeID=usu.UsuarioID
			AND CuentaAhoID=Par_CuentaAhoID;

		SELECT ctas.CuentaAhoID, tip.NumRegistroRECA, cli.NombreCompleto AS nomCliente,
				IFNULL(Var_Ejecutivo,Cadena_Vacia) AS nomEjecutivo
			FROM CUENTASAHO ctas,
				TIPOSCUENTAS tip,
				CLIENTES cli
			WHERE tip.TipoCuentaID=ctas.TipoCuentaID
			AND cli.ClienteID=ctas.ClienteID
			AND ctas.CuentaAhoID=Par_CuentaAhoID;
	END IF;

	IF(Par_NumCon=Con_DispoLegal)THEN
		SELECT ctas.CuentaAhoID, tip.NumRegistroRECA
			FROM CUENTASAHO ctas,
				TIPOSCUENTAS tip
			WHERE tip.TipoCuentaID=ctas.TipoCuentaID
			AND ctas.CuentaAhoID=Par_CuentaAhoID;
	END IF;
END TerminaStore$$