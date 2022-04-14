-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESPORCAJALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESPORCAJALIS`;
DELIMITER $$

CREATE PROCEDURE `OPCIONESPORCAJALIS`(
	Par_TipoCaja		CHAR(2),			-- Tipo de Caja CA: atencion al pub CP: Principal BC: Boveda
	Par_NumLis			TINYINT UNSIGNED,	-- Tipo de Lista

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Lis_Combo 		INT;
	DECLARE	Lis_Reversas	INT;
	DECLARE	Lis_Reimpresion	INT;
	DECLARE SiEsReversa		CHAR(1);
	DECLARE NoEsReversa		CHAR(1);
	DECLARE AplCobertRiesgo INT;
	DECLARE AjusPorSobrante	INT;
	DECLARE AjusPorFaltante	INT;
	DECLARE Lis_GridOpe		INT;
	DECLARE Lis_GridRev		INT;
	DECLARE Entero_Cero		INT;
	DECLARE Lis_PLD			INT;
	DECLARE Lis_SiSujetaPLD	INT;
	DECLARE Str_SI			CHAR(1);
	DECLARE Str_NO			CHAR(1);

	-- Asignacion de Constantes
	SET Lis_Combo			:= 1;
	SET Lis_Reversas		:= 2;
	SET Lis_Reimpresion		:= 3;
	SET SiEsReversa			:='S';
	SET NoEsReversa			:='N';
	SET AplCobertRiesgo		:= 9;	-- Corresponde a OPCIONESCAJA: 9, APLICAR POLIZA COBERTURA DE RIESGO
	SET AjusPorSobrante		:= 27;	-- Corresponde a OPCIONESCAJA: 27, AJUSTE POR SOBRANTE
	SET AjusPorFaltante		:= 28;	-- Corresponde a OPCIONESCAJA: 28, AJUSTE POR FALTANTE
	SET Lis_GridOpe			:= 4;	-- Lista  de operaciones --
	SET Lis_GridRev			:= 5;	-- Lista de Operaciones de reversa --
	SET Lis_PLD				:= 7;	-- Lista de Operaciones que pueden estar sujetas a pld
	SET Lis_SiSujetaPLD		:= 8;	-- Lista de Operaciones si estan sujetas a pld (parametrizable)
	SET Entero_Cero			:= 0;
	SET Str_SI				:= 'S';
	SET Str_NO				:= 'S';

	-- Este tipo de lista tambien se utiliza para cargar un grid en pantalla Opciones Por Caja --
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT 	OC.OpcionCajaID,OC.Descripcion
		FROM OPCIONESCAJA OC,
				OPCIONESPORCAJA OPC
		WHERE OPC.TipoCaja=Par_TipoCaja
			AND OPC.OpcionCajaID=OC.OpcionCajaID
			AND IFNULL(OC.EsReversa, NoEsReversa) = NoEsReversa;
	END IF;

	-- Este tipo de lista tambien se utiliza para cargar un grid en pantalla Opciones Por Caja --
	IF(Par_NumLis = Lis_Reversas) THEN
		SELECT 	OC.OpcionCajaID,OC.Descripcion
		FROM OPCIONESCAJA OC,
				OPCIONESPORCAJA OPC
		WHERE OPC.TipoCaja=Par_TipoCaja
			AND OPC.OpcionCajaID=OC.OpcionCajaID
			AND OC.EsReversa = SiEsReversa;
	END IF;

	IF(Par_NumLis = Lis_Reimpresion) THEN
		SELECT 	OC.OpcionCajaID,OC.Descripcion
		FROM OPCIONESCAJA OC,
				OPCIONESPORCAJA OPC
		WHERE OPC.TipoCaja=Par_TipoCaja
			AND OPC.OpcionCajaID=OC.OpcionCajaID
			AND IFNULL(OC.EsReversa, NoEsReversa) = NoEsReversa
			AND (OPC.OpcionCajaID    <> AjusPorSobrante
				AND OPC.OpcionCajaID <> AjusPorFaltante
				AND OPC.OpcionCajaID <> AplCobertRiesgo);
	END IF;

	-- Lista para llenar el grid de operaciones ventanilla--
	IF(Par_NumLis = Lis_GridOpe) THEN
		SELECT	OC.OpcionCajaID,OC.Descripcion
		FROM OPCIONESCAJA OC
		WHERE IFNULL(OC.EsReversa, NoEsReversa) = NoEsReversa
		AND OpcionCajaID != Entero_Cero;
	END IF;

	-- Lista para llenar el grid de reversas --
	IF(Par_NumLis = Lis_GridRev) THEN
		SELECT OC.OpcionCajaID,OC.Descripcion
		FROM OPCIONESCAJA OC
		WHERE OC.EsReversa = SiEsReversa
		AND OpcionCajaID != Entero_Cero;
	END IF;

	/* Lista No 7
	* Lista de Operaciones que pueden estar sujetas a pld
	* Pantalla: Prevencion PLD -> Parametros -> Operaciones Sujetas a PLD */
	IF(Par_NumLis = Lis_PLD) THEN
		SELECT OC.OpcionCajaID, OC.Descripcion
		  FROM OPCIONESCAJA OC
			WHERE IFNULL(OC.EsReversa, NoEsReversa) = NoEsReversa
				AND EvaluaPLD = Str_SI;
	END IF;

	/* Lista No 8
	* Lista de las Operaciones que si estan sujetas a pld (parametrizable)
	* Pantalla: Prevencion PLD -> Parametros -> Operaciones Sujetas a PLD */
	IF(Par_NumLis = Lis_SiSujetaPLD) THEN
		SELECT OC.OpcionCajaID,
			IFNULL(OC.SujetoPLDIdenti,Str_NO) AS SujetoPLDIdenti,
			IFNULL(OC.SujetoPLDEscala,Str_NO) AS SujetoPLDEscala
			FROM OPCIONESCAJA OC
			WHERE IFNULL(OC.EsReversa, NoEsReversa) 		= NoEsReversa
				AND (IFNULL(OC.SujetoPLDIdenti,Str_NO)		= Str_SI
					  OR IFNULL(OC.SujetoPLDEscala,Str_NO)	= Str_SI);
	END IF;

END TerminaStore$$