-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEACCESORIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEACCESORIOSCON`;DELIMITER $$

CREATE PROCEDURE `DETALLEACCESORIOSCON`(
# =====================================================================================
# ----- SP QUE CONSULTA EL DETALLE DE LOS ACCESORIOS COBRADOS POR UN CREDITO ----------
# =====================================================================================
	Par_CreditoID 			INT(11),			# Numero de Credito
	Par_AcesorioID 			INT(11),			# ID del Accesorio
	Par_TipoConsulta		TINYINT UNSIGNED,	# Tipo de Consulta

	# Parametros de Auditoria
	Aud_EmpresaID 			INT(11),
	Aud_Usuario 			INT(11),
  	Aud_FechaActual 		DATETIME,
  	Aud_DireccionIP 		VARCHAR(15),
  	Aud_ProgramaID 			VARCHAR(50),
  	Aud_Sucursal 			INT(11),
  	Aud_NumTransaccion 		BIGINT(20)
)
TerminaStore:BEGIN

	#Declaración de Variable
    DECLARE Var_MontoIVA 		DECIMAL(12,2); 		# Variable Monto de IVA
    DECLARE Var_IVACliente 		CHAR(1); 			# Variable si el Cliente Paga IVA
    DECLARE Var_ClienteID		INT(11); 			# Variable ID del Cliente
    DECLARE Var_SucCliente		INT(11); 			# Variable Número de Sucursal de Cliente

	# Declaración de Constantes
	DECLARE Con_Principal	INT(11); 			# Constante Consulta Principal 1
    DECLARE StringSi		CHAR(1); 			# Constante Cadena Si
    DECLARE Decimal_Cero	DECIMAL(12,2); 		# Constante Decimal Cero

	# Asignación de Constantes
    SET Con_Principal 	:= 2; 		# Constante Consulta Principal 1
    SET StringSi 		:= 'S'; 	# Constante Cadena Si
    SET Decimal_Cero 	:= 0.00; 	# Constante Decimal Cero


	# Consulta datos generales del accesorio cobrado por un credito
	IF(Par_TipoConsulta=Con_Principal)THEN
		-- Consultas para determinar si el cliente paga IVA y el monto
		SET Var_ClienteID := (SELECT ClienteID FROM CREDITOS WHERE CreditoID=Par_CreditoID);
		SELECT SucursalOrigen,	PagaIVA	INTO Var_SucCliente, Var_IVACliente FROM CLIENTES WHERE ClienteID = Var_ClienteID;
        SET Var_MontoIVA := (SELECT IVA FROM SUCURSALES	WHERE SucursalID = Var_SucCliente);
		SET Var_MontoIVA := IFNULL(Var_MontoIVA,Decimal_Cero);
		-- 1.- Consulta Principal
		SELECT 	CreditoID, 		AccesorioID, 		CobraIVA, 		MontoAccesorio,
		CASE WHEN (CobraIVA=StringSi AND Var_IVACliente=StringSi) THEN
				ROUND(MontoAccesorio*Var_MontoIVA,2)
			ELSE
				Decimal_Cero
            END AS MontoIVAAccesorio,
		SaldoVigente,  MontoPagado,
        CASE WHEN (CobraIVA=StringSi AND Var_IVACliente=StringSi) THEN
				ROUND(SaldoVigente*Var_MontoIVA,2)
			ELSE
				Decimal_Cero
            END AS SaldoIVAAccesorio
		FROM DETALLEACCESORIOS
		WHERE CreditoID = Par_CreditoID
		AND AccesorioID = Par_AcesorioID;
	END IF;

END TerminaStore$$