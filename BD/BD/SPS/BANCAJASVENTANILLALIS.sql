-- BANCAJASVENTANILLALIS

DELIMITER ;
DROP PROCEDURE IF EXISTS BANCAJASVENTANILLALIS;
DELIMITER $$

CREATE PROCEDURE BANCAJASVENTANILLALIS (
-- SP para listar las CAJAS De VENTANILLA
	Par_Descripcion		VARCHAR(50),	-- Descripcion de la caja
	Par_CajaID			INT(11),		-- Numero de caja
	Par_SucursalID		INT(11),		-- Sucursal ID de la caja
	Par_TamanioLista	INT(11),		-- Parametro tamanio de la lista
	Par_PosicionInicial	INT(11),		-- Parametro posicion inicial de la lista
	Par_NumLis			INT(11),		-- Numero de Lista

	Aud_EmpresaID		INT(11),		-- Auditoria
	Aud_Usuario			INT(11),		-- Auditoria

	Aud_FechaActual		DATETIME,		-- Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Auditoria
	Aud_Sucursal		INT(11),		-- Auditoria
	Aud_NumTransaccion	BIGINT			-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CantidadRegistro	INT(11);

    -- Declaracion de Constantes
    DECLARE Lis_Principal	TINYINT UNSIGNED;	-- Lista principal
	DECLARE Entero_Cero		INT(11);			-- Entero cero
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia

	-- Asignacion de Constantes
	SET Lis_Principal	:= 1;
	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:= '';

	SET Par_TamanioLista 	:= IFNULL(Par_TamanioLista, Entero_Cero);
	SET Par_PosicionInicial	:= IFNULL(Par_PosicionInicial, Entero_Cero);
	SET Par_CajaID		 	:= IFNULL(Par_CajaID, Entero_Cero);
	SET Par_Descripcion		:= IFNULL(Par_Descripcion, Cadena_Vacia);

	IF(Par_NumLis = Lis_Principal) THEN

		SELECT COUNT(*)
			INTO Var_CantidadRegistro
		FROM CAJASVENTANILLA;

		IF(Par_TamanioLista = Entero_Cero) THEN
			SET Par_TamanioLista	:= Var_CantidadRegistro;
		END IF;

		SELECT	SucursalID,
				CajaID, CASE TipoCaja
					WHEN 'CA' THEN 'Caja de Atencion al Publico'
					WHEN 'CP' THEN 'Caja Principal de Sucursal'
					WHEN 'BG' THEN 'Boveda Central'
				END AS TipoCaja, 
				UsuarioID, DescripcionCaja,
				Estatus, EstatusOpera,
				SaldoEfecMN, SaldoEfecME, LimiteEfectivoMN, LimiteDesemMN, MaximoRetiroMN,
				EjecutaProceso
		FROM CAJASVENTANILLA
		WHERE SucursalID = IF(Par_SucursalID > Entero_Cero, Par_SucursalID, SucursalID)
		AND	DescripcionCaja like concat("%", Par_Descripcion, "%%")
		AND CajaID = IF(Par_CajaID > Entero_Cero, Par_CajaID, CajaID)
		ORDER BY CajaID
		LIMIT Par_PosicionInicial,Par_TamanioLista;
	END IF;

END TerminaStore$$