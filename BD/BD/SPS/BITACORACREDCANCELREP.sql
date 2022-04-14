-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACREDCANCELREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACREDCANCELREP`;DELIMITER $$

CREATE PROCEDURE `BITACORACREDCANCELREP`(
/*SP PARA GENERAR EL REPORTE DE CREDITOS CANCELADOS*/
	Par_FechaInicio			DATE,				-- Fecha Final del Periodo
	Par_FechaFinal			DATE,				-- Fecha Final del Periodo
	Par_SucursalID			INT(11),			-- Sucursal
	Par_ProductoID			INT(11),			-- Producto ID
	Par_NumCon				INT(11),			-- No. de Lista

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
	DECLARE Var_Sentencia 			TEXT(90000);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Rep_Principal			INT(11);
	DECLARE Fecha_Vacia				DATE;

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Entero_Cero					:= 0;
	SET Rep_Principal				:= 17;
	SET Fecha_Vacia					:= '1900-01-01';

	IF(Par_NumCon = Rep_Principal) THEN
		SET Par_FechaInicio	:= IFNULL(Par_FechaInicio,Fecha_Vacia);
		SET Par_FechaFinal	:= IFNULL(Par_FechaFinal,Fecha_Vacia);
		SET Par_SucursalID	:= IFNULL(Par_SucursalID,Entero_Cero);
		SET Par_ProductoID	:= IFNULL(Par_ProductoID,Entero_Cero);
		SET Var_Sentencia := CONCAT('
		SELECT
			BITA.FechaCancel,		BITA.CreditoID,			CRED.GrupoID,		GRUP.NombreGrupo,		BITA.ClienteID,
			CLI.NombreCompleto,		BITA.MotivoCancel,		BITA.MontoCancel,	BITA.Capital,			BITA.Interes,
			BITA.PolizaID,			BITA.MontoGarantia,		BITA.Comisiones,	BITA.UsuarioCancelID,	BITA.UsuarioAutID,
			CRED.SucursalID,
			SUC.NombreSucurs AS NombreSucursal,
			CRED.ProductoCreditoID AS ProducCreditoID,
			PROD.Descripcion AS NombreProducto,
			USU.NombreCompleto AS NombreUsuario
			FROM BITACORACREDCANCEL AS BITA
				INNER JOIN CREDITOS AS CRED ON BITA.CreditoID = CRED. CreditoID
				INNER JOIN CLIENTES AS CLI ON BITA.ClienteID = CLI.ClienteID
				INNER JOIN PRODUCTOSCREDITO AS PROD ON CRED.ProductoCreditoID = PROD.ProducCreditoID
				INNER JOIN SUCURSALES AS SUC ON CRED.SucursalID = SUC.SucursalID
				INNER JOIN USUARIOS AS USU ON BITA.UsuarioCancelID = USU.UsuarioID
				LEFT JOIN GRUPOSCREDITO AS GRUP ON CRED.GrupoID = GRUP.GrupoID
			 WHERE BITA.FechaCancel BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFinal,'" ');

		IF(Par_SucursalID != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CRED.SucursalID = ',Par_SucursalID);
		END IF;

		IF(Par_ProductoID != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CRED.ProductoCreditoID = ',Par_ProductoID);
		END IF;

		SET @Sentencia	= (Var_Sentencia);
		PREPARE STBITACORACREDCANCELREP FROM @Sentencia;
		EXECUTE  STBITACORACREDCANCELREP;

	END IF;
END TerminaStore$$