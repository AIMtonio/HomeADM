-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDARIOSPORSOLICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBLSOLIDARIOSPORSOLICON`;DELIMITER $$

CREATE PROCEDURE `OBLSOLIDARIOSPORSOLICON`(

	Par_SolicitudCreditoID		INT(11),				-- Identificador solicitud credito
	Par_NumCon					TINYINT UNSIGNED,		-- NumCon

	-- Parametros de Auditoria
	Par_EmpresaID				INT(11),				-- Parametros de Auditoria Identificador de la Empresa
	Aud_Usuario					INT(11),				-- Parametros de Auditoria Usuario
	Aud_FechaActual				DATETIME,				-- Parametros de Auditoria Fecha Actual
	Aud_DireccionIP				VARCHAR(15),			-- Parametros de Auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),			-- Parametros de Auditoria Identificador de programa
	Aud_Sucursal				INT(11),				-- Parametros de Auditoria Sucursal
	Aud_NumTransaccion			BIGINT					-- Parametros de Auditoria Numero de transaccion

	)
TerminaStore: BEGIN

	-- Declaracion de Variables

	DECLARE Mes_Consulta		INT(11);				-- Mes Consulta
	DECLARE Ano_Consulta		INT(11);				-- Anio Consulta
	DECLARE NumAvales			INT(11);				-- Numero de Avales
	DECLARE	Var_CantAvales		INT(11);				-- Cantidad de Avales
	DECLARE Var_CantFilas		INT(11);				-- Cantidad de filas
	DECLARE Var_Vueltas			INT(11);				-- Vueltas
	DECLARE	Var_NumFila			INT(11);				-- Numero de filas
	DECLARE	Var_NumColumna		INT(11);				-- Numero de Columnas
	DECLARE PermisoEntrada		INT(11);				-- Permiso de Entradas

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);				-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);				-- Entero Cero
	DECLARE	Con_Principal		INT(11);				-- Prinsipal
	DECLARE Con_Verifica		INT(11);				-- Verifica numero de obligados solidarios asignados a la solicitud y el estatus de estos
	DECLARE Var_Consecutivo		INT(11);				-- Consecutivo
	DECLARE EsOficial			CHAR(1);				-- ES Oficial

	-- Asignacion de Constantes
	Set	Cadena_Vacia			:= '';					-- Cadena Vacia
	Set	Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	Set	Entero_Cero				:= 0;					-- Entero Cero
	Set	Con_Principal			:= 1;					-- Principal
	Set Con_Verifica			:= 2;					-- Verifica numero de obligados solidarios asignados a la solicitud y el estatus de estos
	Set EsOficial				:= 'S';					-- Es oficial
	Set @Var_Consecutivo		:= 0;					-- Consecutivo

	IF(Par_NumCon = Con_Principal) THEN
		SELECT  OBL.OblSolidID, ifnull(C.ClienteID,0) AS ClienteID, ifnull(P.ProspectoID,0) AS ProspectoID,
			CASE WHEN  OBL.OblSolidID <> 0  AND   OBL.ClienteID = 0 AND OBL.ProspectoID= 0 THEN
				A.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID = 0  AND   OBL.ClienteID <> 0 AND OBL.ProspectoID= 0 THEN
				C.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID = 0  AND   OBL.ClienteID = 0 AND OBL.ProspectoID<> 0 THEN
				P.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID <> 0  AND   OBL.ClienteID <> 0 THEN
				A.NombreCompleto
			ELSE	CASE WHEN  OBL.OblSolidID <> 0  AND   OBL.ProspectoID <> 0 THEN
				A.NombreCompleto END END END END END AS Nombre,
				OBL.TipoRelacionID AS ParentescoID, TR.Descripcion AS NombreParentesco,
				OBL.TiempoDeConocido AS TiempoDeConocido
		FROM OBLSOLIDARIOSPORSOLI OBL
		LEFT OUTER JOIN OBLIGADOSSOLIDARIOS A ON OBL.OblSolidID= A.OblSolidID
		LEFT OUTER JOIN CLIENTES C ON OBL.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON OBL.ProspectoID= P.ProspectoID
		INNER JOIN TIPORELACIONES TR ON OBL.TipoRelacionID= TR.TipoRelacionID
		WHERE OBL.SolicitudCreditoID=Par_SolicitudCreditoID;
	END IF;

	IF(Par_NumCon = Con_Verifica)THEN
		SELECT IFNULL(OBL.SolicitudCreditoID,Entero_Cero) AS SolicitudCreditoID,COUNT(OBL.OblSolidID) as NumOblAsig,
        IFNULL(OBL.Estatus,Cadena_Vacia) AS Estatus
		FROM OBLSOLIDARIOSPORSOLI OBL
		WHERE OBL.SolicitudCreditoID=Par_SolicitudCreditoID
		GROUP BY OBL.Estatus;
	END IF;

END TerminaStore$$