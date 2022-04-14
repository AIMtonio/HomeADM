-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROCON`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROCON`(
	-- =========================================================================
	-- ----------SP PARA CONSULTA LOS CREDITOS CONSOLIDADOS-----------
	-- =========================================================================
	Par_FolioConsolidaID	BIGINT(12),			-- ID de Folio de Consolidacion
	Par_Transaccion			BIGINT(20),			-- Numero de Transaccion de la tabla en sesion
	Par_CreditoID			BIGINT(12),			-- Credito ID
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria Numero de Empresa
	Aud_Usuario				INT(11),			-- Parametro de Auditoria Usuario
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria Fecha
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(12),			-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria Numero Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_SaldoCredito			DECIMAL(14,2);  -- Saldo Actual del Credito
	DECLARE Var_NumRegistros			INT(11);		-- Numero de Registros
	DECLARE Var_MaxRegistros			INT(11);		-- Numero Maximo de Registros
	DECLARE Var_MinRegistros			INT(11);		-- Numero Minimo de Registros
	DECLARE Var_MaxNumPrograma			INT(11);		-- Numero Maximo de programas fira

	DECLARE Var_NumRegistroID			INT(11);		-- Numero de Registros
	DECLARE Var_Validador				INT(11);		-- Validador de Operacion
	DECLARE Var_TipoGarantiaFIRAID		INT(11);		-- Garantia Pivote
	DECLARE Var_ActivaCombo 			INT(11);		-- Validador para activar el combo
	DECLARE Var_ProgEspecialFIRAID		VARCHAR(10);	-- Programa Especial Fira
	DECLARE Var_MaxProgEspecialFIRAID	VARCHAR(10);	-- Numero Maximo del Programa Especial Fira

	DECLARE Var_MinProgEspecialFIRAID	VARCHAR(10);	-- Numero Minimo del Programa Especial Fira


	-- Declaracion de Consultas
	DECLARE	Con_Principal 			TINYINT UNSIGNED;
	DECLARE	Con_AsignaDetalle		TINYINT UNSIGNED;


	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE Entero_Uno				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,2);

	DECLARE	Est_Vigente				CHAR(1);
	DECLARE	Est_Vencido				CHAR(1);
	DECLARE	Est_Pagado				CHAR(1);
	DECLARE StringSI				CHAR(1);
	DECLARE StringNO				CHAR(1);

	DECLARE Rec_Propios				CHAR(1);
	DECLARE Int_Fondeo				CHAR(1);

	-- Asignacion de Consultas
	SET Con_Principal 			:= 1;				-- Consulta Principal
	SET Con_AsignaDetalle 		:= 2;				-- Consulta para Asignación de Detalle de Consolidacion

	-- Asignacion de Constantes
	SET Cadena_Vacia			:='';               -- Cadena Vacia
	SET Fecha_Vacia 			:='1900-01-01';     -- Fecha Vacia
	SET Entero_Cero				:= 0;               -- Constante Entero Cero
	SET Entero_Uno 					:= 1;			-- Constantes Entero Uno
	SET Decimal_Cero			:= 0.0;             -- Constante DEcimal Cero

	SET Est_Vigente 			:= 'V';             -- Estatus VIGENTE
	SET Est_Vencido 			:= 'B';             -- Estatus VENCIDO
	SET Est_Pagado   			:= 'P';             -- Estatus PAGADO
	SET StringSI 				:= 'S';             -- Constante SI
	SET StringNO 				:= 'N';             -- Constante NO

	SET Rec_Propios 			:= 'P';             -- Tipo de Fondeo FIRA Recursos Propios
	SET Int_Fondeo 				:= 'F';             -- Tipo de Fonde FIRA Institucion de Fondeo

	-- Consulta Principal
	IF( Par_NumCon = Con_Principal ) THEN

		SET Var_SaldoCredito := (SELECT	ROUND(SUM(
												IFNULL(ROUND(Amo.SaldoCapVigente,2), Decimal_Cero) + IFNULL(ROUND(Amo.SaldoCapAtrasa,2),  Decimal_Cero) +
												IFNULL(ROUND(Amo.SaldoCapVencido,2), Decimal_Cero) + IFNULL(ROUND(Amo.SaldoCapVenNExi,2), Decimal_Cero) +
												IFNULL(ROUND(Amo.SaldoInteresOrd,2), Decimal_Cero) + IFNULL(ROUND(Amo.SaldoInteresAtr,2), Decimal_Cero) +
												IFNULL(ROUND(Amo.SaldoInteresVen,2), Decimal_Cero) + IFNULL(ROUND(Amo.SaldoInteresPro,2), Decimal_Cero) +
												IFNULL(ROUND(Amo.SaldoIntNoConta,2), Decimal_Cero)), 2)
								 FROM AMORTICREDITO Amo
								 WHERE Amo.CreditoID = Par_CreditoID
								   AND Amo.Estatus <> Est_Pagado);
		SET Var_SaldoCredito := IFNULL(Var_SaldoCredito, Decimal_Cero);

		SELECT Cre.CreditoID AS CreditoID,  Pro.Descripcion AS ProductoCreditoID,   Cre.MontoCredito AS Monto,
			CASE Cre.TipoFondeo
				WHEN Rec_Propios THEN 'R. PROPIOS'
				WHEN Int_Fondeo THEN 'FIRA'
				ELSE 'R. PROPIOS' END AS Fondeo,
			CASE Cre.Estatus
				WHEN Est_Vigente THEN 'VIGENTE'
				WHEN Est_Vencido    THEN 'VENCIDO'
				ELSE 'VIGENTE' END AS Estatus,
			CASE
				WHEN Gar.TipoGarantiaID > Entero_Cero THEN StringSI
				ELSE StringNO END AS GarantiaFIRA,
			CASE WHEN Cre.AporteCliente > Entero_Cero THEN StringSI
				ELSE StringNO END AS GarantiaLiq,
			Var_SaldoCredito AS SaldoActual,
			CONCAT(Pro.Descripcion , ' - $', Cre.MontoCredito) AS Descripcion, Cre.LineaCreditoID
			FROM CREDITOS Cre
				INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
				INNER JOIN CATTIPOGARANTIAFIRA Gar ON Cre.TipoGarantiaFIRAID = Gar.TipoGarantiaID
			WHERE Cre.CreditoID = Par_CreditoID;
	END IF;

	-- Consulta para Asignación de Detalle de Consolidacion
	IF( Par_NumCon = Con_AsignaDetalle ) THEN

		SELECT	Cre.TipoGarantiaFIRAID,
				CASE WHEN Cre.TipoGarantiaFIRAID IN (0,3) THEN 0
					 ELSE 1
				END AS ActivaCombo
		INTO Var_TipoGarantiaFIRAID, Var_ActivaCombo
		FROM CREDCONSOLIDAAGROGRID Det
		INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
		INNER JOIN CATTIPOGARANTIAFIRA Gar ON Cre.TipoGarantiaFIRAID = Gar.TipoGarantiaID
		WHERE Det.FolioConsolida = Par_FolioConsolidaID
		  AND Det.Transaccion = Par_Transaccion
		ORDER BY Det.DetGridID, Det.FolioConsolida
		LIMIT Entero_Uno;


		DROP TABLE IF EXISTS TMP_VALPROGRAMAFIRA;
		CREATE TEMPORARY TABLE TMP_VALPROGRAMAFIRA(
			RegistroID				INT(11)		NOT NULL COMMENT 'ID de TAbla',
			ProgEspecialFIRAID		VARCHAR(10) NOT NULL COMMENT 'Clave del Programa FIRA\n',
			Numero					INT(11)		NOT NULL COMMENT 'Numero de Programas',
			PRIMARY KEY (RegistroID));

		SET @RegistroID := Entero_Cero;
		INSERT INTO TMP_VALPROGRAMAFIRA (RegistroID, ProgEspecialFIRAID, Numero)
		SELECT	(@RegistroID := @RegistroID+1),
				Cre.ProgEspecialFIRAID, COUNT(IFNULL(Cre.ProgEspecialFIRAID, Entero_Cero))
		FROM CREDCONSOLIDAAGROGRID Det
		INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
		INNER JOIN CATFIRAPROGESP Pro ON Cre.ProgEspecialFIRAID = Pro.CveSubProgramaID
		WHERE Det.FolioConsolida = Par_FolioConsolidaID
		  AND Det.Transaccion = Par_Transaccion
		GROUP BY Cre.ProgEspecialFIRAID
		ORDER BY Cre.ProgEspecialFIRAID;

		SELECT 	MIN(IFNULL(RegistroID,Entero_Cero)),	MAX(IFNULL(RegistroID,Entero_Cero))
		INTO 	Var_MinRegistros,						Var_MaxRegistros
		FROM TMP_VALPROGRAMAFIRA;

		SELECT	ProgEspecialFIRAID
		INTO	Var_MinProgEspecialFIRAID
		FROM TMP_VALPROGRAMAFIRA
		WHERE RegistroID = Var_MinRegistros;

		SELECT	ProgEspecialFIRAID
		INTO	Var_MaxProgEspecialFIRAID
		FROM TMP_VALPROGRAMAFIRA
		WHERE RegistroID = Var_MaxRegistros;

		SET Var_MinProgEspecialFIRAID := IFNULL(Var_MinProgEspecialFIRAID, Cadena_Vacia);
		SET Var_MaxProgEspecialFIRAID := IFNULL(Var_MaxProgEspecialFIRAID, Cadena_Vacia);

		SELECT	CASE WHEN Var_MinProgEspecialFIRAID = Var_MaxProgEspecialFIRAID THEN Entero_Cero
					 ELSE Entero_Uno
				END
		INTO Var_Validador;

		IF( Var_Validador > Entero_Cero ) THEN

			-- Obtengo el Programa con mas numero de creditos
			SELECT MAX(IFNULL(Numero, Entero_Cero))
			INTO Var_MaxNumPrograma
			FROM TMP_VALPROGRAMAFIRA;

			SELECT  COUNT(IFNULL(RegistroID, Entero_Cero))
			INTO Var_NumRegistros
			FROM TMP_VALPROGRAMAFIRA
			WHERE Numero =  Var_MaxNumPrograma;

			-- Si el maximo numero de creditos tiene lo comparte mas de un programa quiere se debe de tomar el programa
			-- especial fira del credito con mas deuda
			IF( Var_NumRegistros = Entero_Uno ) THEN

				SELECT ProgEspecialFIRAID
				INTO Var_ProgEspecialFIRAID
				FROM TMP_VALPROGRAMAFIRA
				WHERE Numero = Var_MaxNumPrograma;

			ELSE

				SELECT  Cre.ProgEspecialFIRAID
				INTO 	Var_ProgEspecialFIRAID
				FROM CREDCONSOLIDAAGROGRID Det
				INNER JOIN CREDITOS Cre ON Det.CreditoID = Cre.CreditoID
				INNER JOIN CATFIRAPROGESP Pro ON Cre.ProgEspecialFIRAID = Pro.CveSubProgramaID
				WHERE Det.FolioConsolida = Par_FolioConsolidaID
				  AND Det.Transaccion = Par_Transaccion
				ORDER BY Det.MontoCredito, Cre.ProgEspecialFIRAID DESC
				LIMIT Entero_Uno;
			END IF;
		ELSE

			SET Var_ProgEspecialFIRAID := Var_MinProgEspecialFIRAID;
		END IF;

		SELECT 	Var_ProgEspecialFIRAID AS ProgEspecialFIRAID,
				Var_TipoGarantiaFIRAID AS TipoGarantiaFIRAID,
				Var_ActivaCombo AS ActivaCombo;

		DROP TABLE IF EXISTS TMP_VALPROGRAMAFIRA;

	END IF;

END TerminaStore$$