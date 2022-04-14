-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOLIS`;

DELIMITER $$
CREATE PROCEDURE `LINEASCREDITOLIS`(
	-- Store procedure para la Lista de lineas de credito
	-- Modulo Cartera y Solicitud de Credito Agro
	Par_Cliente				VARCHAR(100),		-- Nombre del Cliente
	Par_ProductCred			VARCHAR(100),		-- Nombre del Producto de Credito
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_ClienteID		INT(11);		-- Numero del Cliente
	DECLARE Var_FechaSistema	DATE;			-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constantes Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constantes Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constantes Entero Cero
	DECLARE EstatusInactivo		CHAR(1);		-- Constantes Estatus Inactivo
	DECLARE EstatusAutoriza		CHAR(1);		-- Constantes Estatus Autorizacion
	DECLARE EstatusBloque		CHAR(1);		-- Constantes Estatus Bloqueado
	DECLARE EstatusCancela		CHAR(1);		-- Constantes Estatus Cancelada
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Con_NO				CHAR(1);		-- Constante NO

	-- Declaracion de Listas
	DECLARE Lis_LineaCredito	INT(11);		-- Lista Linea Credito
	DECLARE Lis_LinCredAlt		INT(11);		-- Lista Linea Credito Alta
	DECLARE Lis_LinCredActivo	INT(11);		-- Lista Linea Credito Activo
	DECLARE Lis_LinCredInact	INT(11);		-- Lista Linea Credito Inactiva
	DECLARE Lis_LinCredBloq		INT(11);		-- Lista Linea Credito Bloqueda
	DECLARE Lis_linCredActBloq	INT(11);		-- Lista Linea Credito Actualizacion Desbloqueo
	DECLARE Lis_Agropecuaria	INT(11);		-- Lista Linea Credito Agropecuaria
	DECLARE Lis_LineaActivaAgro	INT(11);		-- Lista Linea Credito Agropecuaria Activa
	DECLARE Lis_LineaInactiAgro	INT(11);		-- Lista Linea Credito Agropecuaria Inactiva

	-- Declaracion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET EstatusInactivo		:='I';
	SET EstatusAutoriza		:='A';
	SET EstatusBloque		:='B';
	SET EstatusCancela		:='C';
	SET Con_SI				:='S';
	SET Con_NO				:='N';

	-- Declaracion de Listas
	SET	Lis_LineaCredito	:= 1;
	SET	Lis_LinCredAlt		:= 2;
	SET Lis_LinCredActivo	:= 3;
	SET Lis_LinCredInact	:= 4;
	SET Lis_LinCredBloq		:= 5;
	SET Lis_linCredActBloq	:= 6;
	SET Lis_Agropecuaria	:= 7;
	SET Lis_LineaActivaAgro	:= 8;
	SET Lis_LineaInactiAgro	:= 9;


	IF( Par_NumLis = Lis_LineaCredito ) THEN
		SELECT	LC.LineaCreditoID, CTE.NombreCompleto AS ClienteID
		FROM LINEASCREDITO LC, CLIENTES CTE
		WHERE LC.ClienteID = CTE.ClienteID
		  AND LC.Estatus <> EstatusCancela
		  AND CTE.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND LC.EsAgropecuario = Con_NO
		LIMIT 0, 15;
	END IF;

	SET Par_ProductCred :=IFNULL(Par_ProductCred,Cadena_Vacia);
	IF( Par_NumLis = Lis_LinCredAlt ) THEN
		IF( Par_ProductCred = Cadena_Vacia) 	then
			SELECT 	LC.LineaCreditoID,	 PC.Descripcion AS ProductoCreditoID, LC.FechaInicio,	LC.FechaVencimiento
			FROM LINEASCREDITO LC, PRODUCTOSCREDITO PC
			WHERE LC.ClienteID = Par_Cliente
			  AND LC.ProductoCreditoID = PC.ProducCreditoID
			  AND LC.Estatus = EstatusAutoriza
			  AND PC.Descripcion LIKE CONCAT("%", Par_ProductCred, "%")
			  AND LC.EsAgropecuario = Con_NO
			LIMIT 0, 15;
		ELSE
			SELECT 	LC.LineaCreditoID,	 PC.Descripcion AS ProductoCreditoID, LC.FechaInicio,	LC.FechaVencimiento
			FROM LINEASCREDITO LC, PRODUCTOSCREDITO PC
			WHERE LC.ClienteID = Par_Cliente
			  AND LC.ProductoCreditoID = Par_ProductCred
			  AND LC.ProductoCreditoID = PC.ProducCreditoID
			  AND LC.Estatus = EstatusAutoriza
			  AND LC.EsAgropecuario = Con_NO
			LIMIT 0, 15;
		END IF;
	END IF;

	IF( Par_NumLis = Lis_LinCredActivo ) THEN
		SELECT  LC.LineaCreditoID, CTE.NombreCompleto AS ClienteID
		FROM LINEASCREDITO LC, CLIENTES CTE
		WHERE LC.ClienteID = CTE.ClienteID
		  AND LC.Estatus = EstatusAutoriza
		  AND CTE.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND LC.EsAgropecuario = Con_NO
		LIMIT 0, 15;
	END IF;

	IF( Par_NumLis = Lis_LinCredInact ) THEN
		SELECT  LC.LineaCreditoID, CTE.NombreCompleto AS ClienteID
		FROM LINEASCREDITO LC, CLIENTES CTE
		WHERE LC.ClienteID = CTE.ClienteID
		  AND LC.Estatus = EstatusInactivo
		  AND CTE.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND LC.EsAgropecuario = Con_NO
		LIMIT 0, 15;
	END IF;

	IF( Par_NumLis = Lis_LinCredBloq ) THEN
		SELECT  LC.LineaCreditoID, CTE.NombreCompleto AS ClienteID
		FROM LINEASCREDITO LC, CLIENTES CTE
		WHERE LC.ClienteID = CTE.ClienteID
		  AND LC.Estatus = EstatusBloque
		  AND CTE.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND LC.EsAgropecuario = Con_NO
		LIMIT 0, 15;
	END IF;

	IF( Par_NumLis = Lis_linCredActBloq ) THEN
		SELECT  LC.LineaCreditoID, CTE.NombreCompleto AS ClienteID
		FROM LINEASCREDITO LC, CLIENTES CTE
		WHERE LC.ClienteID = CTE.ClienteID
		  AND (LC.Estatus = EstatusAutoriza OR LC.Estatus= EstatusBloque)
		  AND CTE.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND LC.EsAgropecuario = Con_NO
		LIMIT 0, 15;
	END IF;

	IF( Par_NumLis = Lis_Agropecuaria ) THEN
		SELECT Lin.LineaCreditoID, Lin.CuentaID, Cli.NombreCompleto AS ClienteID
		FROM LINEASCREDITO Lin
		INNER JOIN CUENTASAHO Cue ON Lin.CuentaID = Cue.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Cue.ClienteID = Cli.ClienteID
		WHERE Cli.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND Lin.EsAgropecuario = Con_SI
		LIMIT 0, 15;
	END IF;

	IF( Par_NumLis = Lis_LineaActivaAgro ) THEN
		SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

		SET Var_ClienteID := CAST(Par_Cliente AS UNSIGNED);
		SELECT Lin.LineaCreditoID, Tip.Nombre AS Descripcion, Lin.SaldoDisponible, Lin.FechaVencimiento
		FROM LINEASCREDITO Lin
		INNER JOIN TIPOSLINEASAGRO Tip ON Lin.TipoLineaAgroID = Tip.TipoLineaAgroID AND FIND_IN_SET(Par_ProductCred, Tip.ProductosCredito)
		INNER JOIN CLIENTES Cli ON Lin.ClienteID = Cli.ClienteID
		WHERE Lin.ClienteID = Var_ClienteID
		  AND Lin.EsAgropecuario = Con_SI
		  AND Lin.Estatus = EstatusAutoriza
		  AND Lin.FechaInicio <= Var_FechaSistema
		LIMIT 0, 15;
	END IF;


	IF( Par_NumLis = Lis_LineaInactiAgro ) THEN
		SELECT Lin.LineaCreditoID, Lin.CuentaID, Cli.NombreCompleto AS ClienteID
		FROM LINEASCREDITO Lin
		INNER JOIN CUENTASAHO Cue ON Lin.CuentaID = Cue.CuentaAhoID
		INNER JOIN CLIENTES Cli ON Cue.ClienteID = Cli.ClienteID
		WHERE Cli.NombreCompleto LIKE CONCAT("%", Par_Cliente, "%")
		  AND Lin.EsAgropecuario = Con_SI
		  AND Lin.Estatus = EstatusInactivo
		LIMIT 0, 15;
	END IF;


END TerminaStore$$