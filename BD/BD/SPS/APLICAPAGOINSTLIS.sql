-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICAPAGOINSTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICAPAGOINSTLIS`;
DELIMITER $$

CREATE PROCEDURE `APLICAPAGOINSTLIS`(
	-- SP para listas de aplicacion de pagos de instituciones
	Par_FolioNominaID		INT(11),		-- ID del folio
	Par_FolioCargaID		INT(11),		-- Folio de carga
	Par_EmpresaNominaID		INT(11),		-- ID de la empresa de nomina
	Par_FechaInicio			DATE,			-- Fecha de inicio de la consulta
	Par_FechaFin			DATE,			-- Fecha de fin de la consulta
	Par_TipoLis				INT(11),		-- Tipo de lista

	Par_EmpresaID       	INT(11),		-- Parametro de auditoria
    Aud_Usuario         	INT(11),		-- Parametro de auditoria
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria
    Aud_NumTransaccion  	BIGINT(20)		-- Parametro de auditoria
	)
TerminaStore:BEGIN

DECLARE Var_ProductoCredito	VARCHAR(200);	-- Nombre del producto de credito
DECLARE Var_Estatus			CHAR(1);		-- Estatus de Pago de Banco V:Vigente / A:Aplicado

DECLARE Lis_PorAplicarIN	INT(11);		-- Tipo lista por aplicar
DECLARE Est_PorAplicar		CHAR(1);		-- Estatus por aplicar
DECLARE Cadena_Vacia   	 	CHAR(1);		-- Cosntante cadena vacia
DECLARE	Fecha_Vacia			DATE;			-- Constante fecha vacia
DECLARE Entero_Cero    		INT(11);		-- Constante entero cero
DECLARE Lis_Principal		INT(11);		-- Constante para lista principal
DECLARE Lis_Noaplicados		INT(11);		-- Constante para creditos no aplicados
DECLARE Con_Procesado		CHAR(1);		-- Constante Procesado
DECLARE Est_Vigente			CHAR(1);		-- Estatus Vigente
DECLARE Est_Aplicado		CHAR(1);		-- Estatus Aplicado EstatPagBanco

SET Lis_PorAplicarIN		:= 1 ;
SET Est_PorAplicar			:= 'P';

SET Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET Entero_Cero				:= 0;
SET Lis_Principal			:= 3;
SET Lis_Noaplicados			:= 4;
SET Con_Procesado			:='P';
SET Est_Vigente				:= 'V';
SET Est_Aplicado			:= 'A';

IF(Par_TipoLis = Lis_PorAplicarIN)THEN


	SELECT MAX(Estatus)
	INTO Var_Estatus
	FROM DESCNOMINAREAL
	WHERE  EmpresaNominaID = Par_EmpresaNominaID
		AND  FolioCargaID= Par_FolioCargaID;

	IF(Var_Estatus = Con_Procesado)THEN
		-- Si Folio esta Procesado se muestran los Registros que se Aplico el Pago de Institucion
		SET @Consecutivo := 0;
		SELECT @Consecutivo:=(@Consecutivo+1) AS ConsecutivoID, "S" AS EsSeleccionado,
			Pag.FolioNominaID AS FolioNum, Pag.CreditoID, Nom.NoEmpleado AS ClienteID,
			cli.NombreCompleto AS NomEmpleado, Pag.MontoPago AS MontoPagos, p.Descripcion AS ProductoCredito,
			"S" AS EsAplicado
		FROM DESCNOMINAREAL Pag
			INNER JOIN CREDITOS cre ON Pag.CreditoID = cre.CreditoID
			INNER JOIN CLIENTES cli ON cli.ClienteID = cre.ClienteID
			INNER JOIN INSTITNOMINA Inst ON Inst.InstitNominaID = cre.InstitNominaID
			INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = cre.ConvenioNominaID AND Con.InstitNominaID  = Inst.InstitNominaID
			INNER JOIN NOMINAEMPLEADOS Nom ON Nom.InstitNominaID = Inst.InstitNominaID AND Nom.ConvenioNominaID = Con.ConvenioNominaID AND Nom.ClienteID = cli.ClienteID
			INNER JOIN PRODUCTOSCREDITO p ON cre.ProductoCreditoID = p.ProducCreditoID
	    WHERE  EmpresaNominaID = Par_EmpresaNominaID
			AND Pag.FolioProcesoID= Par_FolioCargaID
			AND Pag.Estatus = Con_Procesado
			AND Pag.EstatPagBanco = Est_Aplicado
		ORDER BY cre.CreditoID,  Pag.FolioNominaID ASC;

	ELSE
		-- Si el Folio no esta procesado se muestran todos los Registros para aplicar el Pago de Institucion
		SET @Consecutivo := 0;
		SELECT @Consecutivo:=(@Consecutivo+1) AS ConsecutivoID, "N" AS EsSeleccionado,
			Pag.FolioNominaID AS FolioNum, Pag.CreditoID, Nom.NoEmpleado AS ClienteID,
			cli.NombreCompleto AS NomEmpleado, Pag.MontoPago AS MontoPagos, p.Descripcion AS ProductoCredito,
			"N" AS EsAplicado
			FROM DESCNOMINAREAL Pag
			INNER JOIN CREDITOS cre ON Pag.CreditoID = cre.CreditoID
			INNER JOIN CLIENTES cli ON cli.ClienteID = cre.ClienteID
			INNER JOIN INSTITNOMINA Inst ON Inst.InstitNominaID = cre.InstitNominaID
			INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = cre.ConvenioNominaID AND Con.InstitNominaID  = Inst.InstitNominaID
			INNER JOIN NOMINAEMPLEADOS Nom ON Nom.InstitNominaID = Inst.InstitNominaID AND Nom.ConvenioNominaID = Con.ConvenioNominaID  AND Nom.ClienteID = cli.ClienteID
			INNER JOIN PRODUCTOSCREDITO p ON cre.ProductoCreditoID = p.ProducCreditoID
			WHERE  Pag.EmpresaNominaID = Par_EmpresaNominaID
			AND  Pag.FolioCargaID= Par_FolioCargaID
			ORDER BY cre.CreditoID,  Pag.FolioNominaID ASC;
	END IF;

END IF;

IF(Par_TipoLis = Lis_Principal)THEN

	SELECT NOM.FolioCargaID AS FolioNominaID, MAX(NOM.FechaCarga) AS FechaPagoIns,
			CASE MAX(NOM.Estatus)
				WHEN 'A' THEN 'VIGENTE'
				WHEN 'P' THEN 'APLICADO'
				ELSE ''
			END AS Estatus
	FROM BECARGAPAGNOMINA BE
			INNER JOIN DESCNOMINAREAL NOM ON BE.FolioCargaID = NOM.FolioCargaID
	  	WHERE NOM.EmpresaNominaID = Par_EmpresaNominaID
		AND NOM.FechaCarga >= Par_FechaInicio
	    AND  NOM.FechaCarga <= Par_FechaFin
		GROUP BY NOM.FolioCargaID
	ORDER BY NOM.FolioCargaID DESC;

END IF;

-- LISTA PARA CREDITOS NO APLICADOS
IF(Par_TipoLis = Lis_Noaplicados)THEN
	SET @Consecutivo := 0;
	SELECT @Consecutivo:=(@Consecutivo+1) AS ConsecutivoID, "N" AS EsSeleccionado,
			Pag.FolioNominaID AS FolioNum, Pag.CreditoID, Nom.NoEmpleado AS ClienteID,
			cli.NombreCompleto AS NomEmpleado, Pag.MontoPago AS MontoPagos, p.Descripcion AS ProductoCredito
		FROM DESCNOMINAREAL Pag
		INNER JOIN CREDITOS cre ON Pag.CreditoID = cre.CreditoID
		INNER JOIN CLIENTES cli ON cli.ClienteID = cre.ClienteID
		INNER JOIN INSTITNOMINA Inst ON Inst.InstitNominaID = cre.InstitNominaID
		INNER JOIN CONVENIOSNOMINA Con ON Con.ConvenioNominaID = cre.ConvenioNominaID AND Con.InstitNominaID  = Inst.InstitNominaID
		INNER JOIN NOMINAEMPLEADOS Nom ON  Nom.InstitNominaID = Inst.InstitNominaID AND Nom.ConvenioNominaID = Con.ConvenioNominaID  AND Nom.ClienteID = cli.ClienteID
		INNER JOIN PRODUCTOSCREDITO p ON cre.ProductoCreditoID = p.ProducCreditoID
		WHERE Pag.FolioCargaID < Par_FolioCargaID
			AND Pag.Estatus = Con_Procesado
			AND Pag.EstatPagBanco = Est_Vigente
			AND cli.Estatus <> 'I'
			AND cre.Estatus <> 'K'
			AND cre.Estatus <> 'P'
		    AND  Pag.EmpresaNominaID = Par_EmpresaNominaID;

END IF;


END TerminaStore$$