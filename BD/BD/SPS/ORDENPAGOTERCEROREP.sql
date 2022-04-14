-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORDENPAGOTERCEROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORDENPAGOTERCEROREP`;DELIMITER $$

CREATE PROCEDURE `ORDENPAGOTERCEROREP`(
	Par_CreditoID	BIGINT(12),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		BIGINT(11),
	Aud_NumTransaccion	BIGINT(20)

	)
TerminaStore: BEGIN
-- Declaracion de variables
DECLARE Var_InstitucionID 		INT(11);
DECLARE Var_MunicipioEmpID 		INT(11);
DECLARE Var_EstadoEmpID 		INT(11);
DECLARE Var_NombreEstado 		VARCHAR(100);
DECLARE Var_NombreMunicipio 	VARCHAR(100);
DECLARE Var_FechaSis			DATE;
DECLARE Var_Total				DECIMAL(12,2);
DECLARE Var_SolicitudCreditoID	INT(11);
DECLARE Var_CreditoID			BIGINT(12);
DECLARE Var_ClienteID			INT(11);
DECLARE Var_Estatus				CHAR(1);

-- Declaracion de constantes
DECLARE Cadena_Vacia	CHAR(2);
DECLARE Sin_Espacio		CHAR(1);
DECLARE Autorizada		CHAR(1);
DECLARE Empresa_Uno		INT(11);
DECLARE Desembolsada      CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE EstatusInactiva		CHAR(1);
DECLARE Entero_Cero		INT;

-- Asignacion de constantes
SET Sin_Espacio		:='';
SET Autorizada		:='A';
SET Desembolsada	:='D';
SET EstatusInactiva	:='I';
SET Empresa_Uno		:=1;
SET Fecha_Vacia		:='1900-01-01';
SET Decimal_Cero	:=0.00;
SET Entero_Cero		:=0;


SET Var_FechaSis :=IFNULL((SELECT FechaSistema
						FROM PARAMETROSSIS), Fecha_Vacia);

SELECT InstitucionID
	INTO Var_InstitucionID
	FROM PARAMETROSSIS
	WHERE EmpresaID = Empresa_Uno;

SELECT MunicipioEmpresa, EstadoEmpresa
	INTO Var_MunicipioEmpID, Var_EstadoEmpID
	FROM INSTITUCIONES
	WHERE InstitucionID = Var_InstitucionID;

SELECT Nombre
	INTO Var_NombreEstado
	FROM ESTADOSREPUB
	WHERE EstadoID = Var_EstadoEmpID;

SELECT  Nombre
	INTO Var_NombreMunicipio
	FROM MUNICIPIOSREPUB
	WHERE MunicipioID = Var_MunicipioEmpID
	AND EstadoID = Var_EstadoEmpID;

SELECT c.SolicitudCreditoID, c.CreditoID, c.ClienteID, Estatus
		INTO Var_SolicitudCreditoID, Var_CreditoID,Var_ClienteID, Var_Estatus
		FROM CREDITOS c
		WHERE CreditoID = Par_CreditoID;

SET Var_SolicitudCreditoID	:=IFNULL(Var_SolicitudCreditoID,Entero_Cero);
SET Var_CreditoID			:=IFNULL(Var_CreditoID, Entero_Cero);
SET Var_ClienteID			:=IFNULL(Var_ClienteID,Entero_Cero );
SET Var_Estatus				:=IFNULL(Var_Estatus, Sin_Espacio);


IF (Var_Estatus = Autorizada OR Var_Estatus = EstatusInactiva)THEN
		SET Var_Total :=(SELECT SUM(Amo.Capital+Amo.Interes+Amo.IVAInteres)
			FROM AMORTICREDITO Amo
				WHERE Amo.CreditoID = Par_CreditoID);
	ELSE
		SET Var_Total	:=(SELECT	SUM(Pag.Capital+Pag.Interes+Pag.IVAInteres) AS montoCuota
			FROM PAGARECREDITO Pag
				WHERE Pag.CreditoID = Par_CreditoID);
END IF;

SET Var_Total := IFNULL(Var_Total,Decimal_Cero );

SELECT Var_SolicitudCreditoID AS SolicitudCreditoID, Var_CreditoID AS CreditoID, Var_ClienteID AS ClienteID, cl.RFC, s.NumAmortizacion,s.FrecuenciaInt, s.MontoAutorizado,
		s.MontoCuota, s.InstitucionNominaID, s.FolioCtrl,i.NombreInstit, NOW() AS FechaActual, p.ProducCreditoID,
		p.RegistroRECA, CONCAT(cl.PrimerNombre,
            (CASE
                WHEN IFNULL(cl.SegundoNombre, Sin_Espacio) != Sin_Espacio THEN CONCAT(' ', cl.SegundoNombre)
                ELSE Sin_Espacio
            END),
            (CASE
                WHEN IFNULL(cl.TercerNombre, Sin_Espacio) != Sin_Espacio THEN CONCAT(' ', cl.TercerNombre)
                ELSE Sin_Espacio
            END),' ',cl.ApellidoPaterno,' ',cl.ApellidoMaterno) AS NombreCompleto, Var_NombreMunicipio, Var_NombreEstado, Var_FechaSis AS Fecha, Var_Total
	FROM SOLICITUDCREDITO s
	INNER JOIN CLIENTES cl ON cl.ClienteID = s.ClienteID
	INNER JOIN INSTITNOMINA i 	ON i.InstitNominaID = s.InstitucionNominaID
	INNER JOIN PRODUCTOSCREDITO p 	ON p.ProducCreditoID = s.ProductoCreditoID
	WHERE s.SolicitudCreditoID = Var_SolicitudCreditoID
	AND s.Estatus IN (Autorizada, Desembolsada);

END TerminaStore$$