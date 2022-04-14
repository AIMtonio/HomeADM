-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERCREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERCREDLIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAHEADERCREDLIS`(
	-- Store procedure para listar la informacion correspondiente al encabezado y detalle de creditos del cliente en el estado de cuenta
	Par_ClienteID						INT(11),					-- Identificador del cliente

	Par_NumLis							TINYINT UNSIGNED,			-- Numero de lista

	Par_EmpresaID						INT(11),					-- Parametro de Auditoria
	Aud_Usuario							INT(11),					-- Parametro de Auditoria
	Aud_FechaActual						DATETIME,					-- Parametro de Auditoria
	Aud_DireccionIP						VARCHAR(15),				-- Parametro de Auditoria
	Aud_ProgramaID						VARCHAR(50),				-- Parametro de Auditoria
	Aud_Sucursal						INT(11),					-- Parametro de Auditoria
	Aud_NumTransaccion					BIGINT(12)					-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Lis_Principal				INT(11);					-- Consulta principal
	DECLARE Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal					:= 1;						-- Consulta principal de cabecera y detalle de los creditos pertenecientes a un cliente
	SET Cadena_Vacia					:= '';						-- Asignacion de cadena vacia

	-- LISTA DEL DETALLE Y CABECERA DE LOS CREDITOS PERTENECIENTES A UN CLIENTE
	IF (Lis_Principal = Par_NumLis)THEN
		SELECT	Head.CreditoID,							Head.NombreProducto,					Head.MontoOtorgado,						Head.ClienteID,				Head.FechaVencimiento,
				Head.SaldoInsoluto,						Head.SaldoInicial,						Head.Pagos,								Head.Cat, 					Head.TasaFija,
				Head.TasaMoratoria,						Head.IntPagadoPerido,					Head.TotalComisionesPagar,				Head.IvaComPagadoPeriodo,	Head.TotalPagar,
				Head.CapitalApagar,						Head.InteresNormalApagar,				Head.IvaInteresNomalApagar,				Head.OtrosCargosApagar,		Head.IvaOtrosCargosApagar,
				Head.FechaProxPagoLeyenda,				Head.IvaIntPagadoPerido,				Detail.FechaOperacion,					Detail.Descripcion,			Detail.Cargos,
				Detail.Abonos,							SUC.NombreSucurs,						Head.Moratorios,						Head.IVAMoratorios,			Head.SalMontoAccesorio,
				Head.SalIVAAccesorio,					Head.CuoMontoAccesorio,					Head.CuoIVAAccesorio,					Head.LitrosMeta AS Meta,	Head.TotalLitros AS Total,
				Head.LitConsumidos AS Consumidos
		FROM EDOCTAHEADERCRED Head
		INNER JOIN EDOCTADETCRE Detail ON Head.CreditoID = Detail.CreditoID
		INNER JOIN SUCURSALES SUC ON Detail.SucursalID =  SUC.SucursalID
		WHERE Head.ClienteID =  Par_ClienteID;
	END IF;

END TerminaStore$$