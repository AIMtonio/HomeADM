-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINVGARLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOINVGARLIS`;DELIMITER $$

CREATE PROCEDURE `CREDITOINVGARLIS`(
	/* Lista las inversiones relacionadas a un credito  */
	Par_CreditoID		BIGINT(12),			/* ID DEL CREDITO*/
	Par_ClienteID		INT(11),			/* ID del Cliente*/
	Par_InversionID		INT(11),			/* ID DE la inversion*/
	Par_NombreCliente	VARCHAR(50),		/* nombre del cliente para filtar la lista */
	Par_NumLis			TINYINT UNSIGNED,	/* TIPO DE LISTA*/

	Par_EmpresaID		INT(11),
	Par_Usuario			INT(11),
	Par_FechaActual		DATE,
	Par_DireccionIP		VARCHAR(15),
	Par_ProgramaID		VARCHAR(50),

	Par_Sucursal		INT(11),
	Par_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

/* Declaracion de constantes */
DECLARE	Entero_Cero			INT;
DECLARE Lis_Principal		INT;
DECLARE Lis_Asigna			INT;
DECLARE Lis_AsignaCre		INT;
DECLARE Lis_CreAutVigVenGar	INT;
DECLARE Lis_InverGar		INT;
DECLARE Est_Vigente			CHAR(1);	/* Estatus Vigente*/
DECLARE Est_VigenteCre		CHAR(1);	/* Estatus Vigente de creditos*/
DECLARE Est_Vencido			CHAR(1);	/* Estatus Vencido*/
DECLARE Est_Pagado			CHAR(1);	/* Estatus pagado*/
DECLARE Est_Autorizado		CHAR(1);	/* Estatus Autorizado*/
DECLARE Var_NoAsignada		CHAR(1);	/* Calificacion no asignada */
DECLARE Var_SI				CHAR(1);	/* Valor para un SI*/

/* Declaracion de Variables */
DECLARE Var_DiasFaltaPago	INT(11);
DECLARE Var_FechaSistema	DATE;
DECLARE Var_ClienteID		INT(11);
DECLARE Var_CalificaCredito CHAR(1);	/*guarda la calificacion del cliente*/

/* Asignacion de contantes*/
SET Entero_Cero			:= 0;
SET Lis_Principal		:= 1;
SET Lis_Asigna			:= 2;	/* lista las inversiones asignadas*/
SET Lis_AsignaCre		:= 3;	/* lista los creditos asignados a una inversion se ocupa en la liberacion*/
SET Lis_CreAutVigVenGar	:= 4;	/* lista los creditos autorizados, vigentes o vencidos que tengan una inversion en garantia*/
SET Lis_InverGar		:= 5;	/* lista las inversiones que esten en garantia por algun crediro*/
SET Est_Vigente			:= 'N';	/* Estatus Vigente de INVERSIONES*/
SET Est_VigenteCre		:= 'V';	/* Estatus VIGENTE de CREDITOS*/
SET Est_Vencido			:= 'B';	/* Estatus Vencido de CREDITOS*/
SET Est_Pagado			:= 'P';	/* Estatus Pagado de CREDITOS*/
SET Est_Autorizado		:= 'A';	/* Estatus Autorizado de CREDITOS*/
SET Var_SI				:= 'S';	/* Valor para un SI*/

IF(Par_NumLis = Lis_Principal) THEN

	SELECT	IV.InversionID,		IV.Etiqueta,	FORMAT(IV.Monto,2) AS Monto,	IV.FechaVencimiento
	FROM	INVERSIONES		IV,
			CLIENTES		CL
		WHERE	CL.ClienteID 		= IV.ClienteID
		 AND 	IV.ClienteID		= Par_ClienteID
		 AND 	IV.Estatus			= Est_Vigente
		 AND 	IV.InversionID NOT IN (SELECT  CI.InversionID
											FROM 	(SELECT CI.InversionID, SUM(MontoEnGar) AS Total, IV.Monto
														FROM CREDITOINVGAR	CI,
															 INVERSIONES	IV
														WHERE	CI.InversionID  = IV.InversionID
														 AND 	IV.ClienteID 	= Par_ClienteID
														 AND 	IV.Estatus			= Est_Vigente
														GROUP BY CI.InversionID
														HAVING total = IV.Monto) AS CI)
		 ORDER BY IV.FechaVencimiento,	IV.InversionID,	IV.Etiqueta,	IV.Monto DESC;
END IF;

/* lista las inversiones asignadas a un credito */
IF(Par_NumLis = Lis_Asigna) THEN
	SELECT	CG.CreditoInvGarID,	IV.InversionID,		IV.Etiqueta,	FORMAT(IV.Monto,2) AS Monto,	FORMAT(CG.MontoEnGar,2) AS MontoEnGar,
			IV.FechaVencimiento
	FROM	CREDITOINVGAR	CG,
			INVERSIONES		IV
		WHERE	CG.InversionID 		= IV.InversionID
		 AND 	CG.CreditoID		= Par_CreditoID
		 ORDER BY CG.FechaAsignaGar;
END IF;

/* lista los creditos asignados a una inversion */
IF(Par_NumLis = Lis_AsignaCre) THEN
	SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS;
	SELECT	CR.CreditoID,		FORMAT(CR.MontoCredito,2) AS MontoCredito,	CR.FechaVencimien,		FORMAT(CG.MontoEnGar,2) AS MontoEnGar ,		IFNULL(CALCULADIASATRASO(CR.CreditoID),0) AS DiasAtraso,
			CG.CreditoInvGarID,	IFNULL(CR.PorcGarLiq,0) AS PorcGarLiq,	 	CR.Estatus,		CASE CR.Estatus WHEN 'I' THEN 'INACTIVO'
																								WHEN 'A' THEN 'AUTORIZADO'
																								WHEN 'V' THEN 'VIGENTE'
																								WHEN 'P' THEN 'PAGADO'
																								WHEN 'C' THEN 'CANCELADO'
																								WHEN 'B' THEN 'VENCIDO'
																								WHEN 'K' THEN 'CASTIGADO'
																								ELSE CR.Estatus END AS EstatusDes
		FROM	CREDITOINVGAR	CG
			INNER JOIN CREDITOS		CR
		WHERE	CG.CreditoID	= CR.CreditoID
		 AND	CG.InversionID	= Par_InversionID;
END IF;

/* lista los creditos: AUTORIZADOS, VIGENTES O VENCIDOS, que su producto de credito indique que requiere garantia liquida
	y que tengan alguna inversion en garantia . */
IF(Par_NumLis = Lis_CreAutVigVenGar) THEN
	SELECT	CR.CreditoID,		c.NombreCompleto AS NombreCompleto , CR.Estatus,	CR.FechaInicio, CR.FechaVencimien,
			pro.Descripcion,	CASE CR.Estatus WHEN 'I' THEN 'INACTIVO'
									WHEN 'A' THEN 'AUTORIZADO'
									WHEN 'V' THEN 'VIGENTE'
									WHEN 'P' THEN 'PAGADO'
									WHEN 'C' THEN 'CANCELADO'
									WHEN 'B' THEN 'VENCIDO'
									WHEN 'K' THEN 'CASTIGADO'
									ELSE CR.Estatus END AS EstatusDes
		FROM	CREDITOS			CR ,
				CLIENTES			c,
				PRODUCTOSCREDITO	pro,
				CREDITOINVGAR		CI
		WHERE 	CR.ClienteID	=c.ClienteID
			AND	c.NombreCompleto	LIKE CONCAT("%", Par_NombreCliente, "%")
			AND (	CR.Estatus	= Est_Autorizado OR
					CR.Estatus	= Est_VigenteCre OR
					CR.Estatus	= Est_Vencido	)
			AND	CR.ProductoCreditoID = pro.ProducCreditoID
			AND CR.CreditoID	= CI.CreditoID
			AND pro.Garantizado	= Var_SI
		GROUP BY CR.CreditoID, 		c.NombreCompleto,	CR.Estatus,		CR.FechaInicio,
				 CR.FechaVencimien,	pro.Descripcion,	CR.Estatus
		ORDER BY CR.Estatus =  Est_Vencido, CR.Estatus = Est_Vigente, CR.Estatus = Est_Autorizado
		LIMIT 0, 15;
END IF;

/* lista las inversiones que esten repaldando a algun credito*/
IF(Par_NumLis = Lis_InverGar) THEN
	SELECT	IV.InversionID,  CL.NombreCompleto,	IV.Etiqueta,	FORMAT(IV.Monto,2) AS Monto
	FROM	INVERSIONES		IV,
			CLIENTES		CL,
			CREDITOINVGAR	CI
	WHERE	IV.ClienteID	= CL.ClienteID
	 AND	IV.InversionID	= CI.InversionID
	 AND	CL.NombreCompleto LIKE CONCAT('%',Par_NombreCliente,'%')
	GROUP BY IV.InversionID,  CL.NombreCompleto,	IV.Etiqueta,	IV.Monto
	LIMIT 0,15;
END IF;


END TerminaStore$$