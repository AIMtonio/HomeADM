-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTALIQUIDACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTALIQUIDACIONCON`;

DELIMITER $$
CREATE PROCEDURE `CARTALIQUIDACIONCON`(
-- =====================================================================================
-- ------- STORED PARA CONSULTA DE CARTAS DE LIQUIDACION ---------
-- =====================================================================================
	Par_CreditoID			BIGINT(12),			-- CreditoID para la carta de liquidación
	Par_ClienteID			INT(11),			-- Identificardor del Cliente de la carta de liquidación
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Var_Principal		INT;				-- Consulta Principal.
	DECLARE Var_Expediente		INT;				-- Consulta Expediente
	DECLARE Var_MontoProy		INT;				-- Consulta del Monto Proyectado
	DECLARE	Var_Activa			CHAR(1);			-- Constante Activo para regresar un solo valor.
	DECLARE	Var_Cero			INT;				-- Constante 0
	DECLARE	Var_CadenaVacia		CHAR(1);			-- Comentarios de variables para todas
	DECLARE	Var_NO				CHAR(1);			-- Variable NO
	DECLARE	Var_SI				CHAR(1);			-- Variable SI
	DECLARE Var_ClienteCred		INT;				-- Consulta Carta Interna por cliente y Crédito

	-- ASIGNACION DE CONSTANTES
	SET	Var_Principal		:= 1;
	SET Var_Expediente		:= 2;
	SET Var_MontoProy		:= 3;
	SET Var_ClienteCred		:= 4;
	SET	Var_Activa			:= 'A';
	SET	Var_Cero			:= 0;
	SET	Var_CadenaVacia		:= '';
	SET	Var_SI				:= 'S';
	SET	Var_NO				:= 'N';

	-- Consulta 1
	IF(Par_NumCon = Var_Principal) THEN
		SELECT	Cliq.CartaLiquidaID,	Cliq.CreditoID,			Cliq.ClienteID,	Cli.NombreCompleto,	Cre.MontoCredito AS MontoOriginal,
				Cliq.FechaVencimiento,	Cliq.InstitucionID,		Ins.Nombre,		Cliq.Convenio
			FROM CARTALIQUIDACION AS Cliq
			INNER JOIN CLIENTES AS Cli ON Cliq.ClienteID = Cli.ClienteID
			INNER JOIN INSTITUCIONES AS Ins ON Cliq.InstitucionID = Ins.InstitucionID
			INNER JOIN CREDITOS AS Cre ON Cre.CreditoID = Cliq.CreditoID
			WHERE	Cliq.CreditoID	= Par_CreditoID
			  AND	Cliq.Estatus	= Var_Activa;
	END IF;

	IF(Par_NumCon = Var_Expediente) THEN
		SELECT 	Liq.CreditoID,	Liq.FechaVencimiento,	Exp.Comentario,	Exp.Recurso, Exp.DigCreaID
			FROM CARTALIQUIDACION Liq INNER JOIN CREDITOARCHIVOS Exp
				ON Exp.DigCreaID = Liq.ArchivoIDCarta
				WHERE	Liq.CreditoID	= Par_CreditoID
				  AND	Liq.Estatus		= Var_Activa;
	END IF;

	IF(Par_NumCon = Var_MontoProy) THEN
		SELECT Cliq.CreditoID, Cliq.FechaRegistro, Det.MontoLiquidar, IFNULL(Usu.Clave,Var_CadenaVacia) AS Clave
			FROM CARTALIQUIDACION AS Cliq INNER JOIN  CARTALIQUIDACIONDET Det
					ON Cliq.CartaLiquidaID = Det.CartaLiquidaID LEFT JOIN USUARIOS Usu
						ON Usu.UsuarioID = Cliq.Usuario
				WHERE	Cliq.CreditoID	= Par_CreditoID
				  AND	Cliq.Estatus	= Var_Activa;
	END IF;


	-- Consulta Carta interna por cliente y crédito
	IF(Par_NumCon = Var_ClienteCred) THEN
		SELECT	Cliq.CartaLiquidaID,	Cliq.CreditoID,			Cliq.ClienteID,	Cli.NombreCompleto,	Cre.MontoCredito AS MontoOriginal,
				Cliq.FechaVencimiento,	Cliq.InstitucionID,		Ins.Nombre,		Cliq.Convenio
			FROM CARTALIQUIDACION AS Cliq
			INNER JOIN CLIENTES AS Cli ON Cliq.ClienteID = Cli.ClienteID
			INNER JOIN INSTITUCIONES AS Ins ON Cliq.InstitucionID = Ins.InstitucionID
			INNER JOIN CREDITOS AS Cre ON Cre.CreditoID = Cliq.CreditoID
			WHERE	Cliq.CreditoID	= Par_CreditoID
			  AND	Cliq.ClienteID	= Par_ClienteID
			  AND	Cliq.Estatus	= Var_Activa;
	END IF;



END TerminaStore$$