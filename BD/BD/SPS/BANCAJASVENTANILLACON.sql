-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCAJASVENTANILLACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCAJASVENTANILLACON`;
DELIMITER $$


CREATE PROCEDURE `BANCAJASVENTANILLACON`(
# =================================================================
# -- SP PARA CONSULTAR LA INFORMACION DE UNA CAJA DE VENTANILLA --
# =================================================================
	Par_CajaID				INT(11),				-- Numero de Caja
	Par_UsuarioID			INT(11),				-- ID o Numero de Usuario
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de Lista

	Par_Empresa				INT(11),				-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de variables
	

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);				-- Cadena VAcia
	DECLARE	Fecha_Vacia			DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);				-- Entero Cero
	DECLARE Var_ResCaja			INT(11);				-- Opcion de consulta para resumen de caja
	DECLARE Var_CP				CHAR(2);				-- Caja Principal
	DECLARE Var_CA				CHAR(2);				-- Caja de Atencion al Publico
	DECLARE Var_BG				CHAR(2);				-- Bodega Central
	DECLARE Var_DescCP			VARCHAR(20);			-- Descripcion de Caja Principal
	DECLARE Var_DescCA			VARCHAR(50);			-- Descripcion de Caja de Atencion al Publico
	DECLARE Var_DescBG			VARCHAR(20);			-- Descripcion de Bodega Central
	
	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';					-- Cadena VAcia
	SET	Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero				:= 0;					-- Entero Cero
	SET Var_ResCaja				:= 1; 					-- Opcion de consulta para resumen de caja
	SET Var_CP					:= 'CP';				-- Caja Principal
	SET Var_CA					:= 'CA';				-- Caja de Atencion al Publico
	SET Var_BG					:= 'BG';				-- Bodega Central
	SET Var_DescCP				:= 'Caja Principal';	-- Descripcion de Caja Principal
	SET Var_DescCA				:= 'Caja de Atencion al Publico';		-- Descripcion de Caja de Atencion al Publico
	SET Var_DescBG				:= 'Boveda Central';	-- Descripcion de Bodega Central

	-- Opcion 1 .- de consulta para resumen de caja
	IF(Par_NumCon = Var_ResCaja) THEN
		SELECT 	CajaID, 		  		TipoCaja, 				SucursalID, 			UsuarioID, 					DescripcionCaja,
				SaldoEfecMN,			SaldoEfecME,			LimiteEfectivoMN,		LimiteDesemMN,				MaximoRetiroMN,
				EjecutaProceso,			CASE TipoCaja
											WHEN Var_CP THEN Var_DescCP
											WHEN Var_CA THEN Var_DescCA
											WHEN Var_BG THEN Var_DescBG
										END AS DescTipoCaja
		FROM CAJASVENTANILLA
		WHERE UsuarioID = Par_UsuarioID;
	END IF;
END TerminaStore$$ 
