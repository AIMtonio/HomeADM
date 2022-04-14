-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSBLOQUEOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSBLOQUEOSCON`;
DELIMITER $$


CREATE PROCEDURE `TIPOSBLOQUEOSCON`(
	Par_TiposBloqID		INT(11),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN

	DECLARE Var_CobraGarFin		CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE DepGarantia			INT;
	DECLARE	Lis_Principal 		INT;
	DECLARE	Lis_DepGarantia		INT;
	DECLARE Lis_DesBloqueo		INT(11);
	DECLARE Lis_DepGarFOGAFI	INT(11);
	DECLARE Var_Activo  		CHAR(1);
	DECLARE Var_Manual 			CHAR(1);
	DECLARE LlaveGarFinanciada	VARCHAR(100);
	DECLARE DepGarFOGAFI		INT(11);

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET	Lis_DepGarantia		:= 2;
	SET Lis_DesBloqueo		:= 3;
	SET Lis_DepGarFOGAFI	:= 4;
	SET DepGarantia			:= 8;

	SET Var_Activo			:='A';
	SET Var_Manual	 		:='M';  -- Desbloqueo o Bloqueo manual
	SET LlaveGarFinanciada	:= 'CobraGarantiaFinanciada';
	SET DepGarFOGAFI		:= 20;

	SET Var_CobraGarFin := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = LlaveGarFinanciada);
	SET Var_CobraGarFin := IFNULL(Var_CobraGarFin, Cadena_Vacia);


	IF(Par_NumLis = Lis_Principal) THEN
		IF(Var_CobraGarFin = 'N') THEN
			SELECT TiposBloqID, Descripcion FROM TIPOSBLOQUEOS
				WHERE Estatus=Var_Activo
					AND TipoMovimiento = Var_Manual
					AND TiposBloqID <> 20
                    AND NatTipoBloq IN('B','A')
				LIMIT 0, 15;

		ELSE
			SELECT TiposBloqID, Descripcion FROM TIPOSBLOQUEOS
				WHERE Estatus=Var_Activo
					AND TipoMovimiento = Var_Manual
                    AND NatTipoBloq IN('B','A')
				LIMIT 0, 15;
	    END IF;
	END IF;

	IF(Par_NumLis = Lis_DesBloqueo) THEN

	    SELECT TiposBloqID, Descripcion FROM TIPOSBLOQUEOS
		WHERE Estatus=Var_Activo
			AND TipoMovimiento = Var_Manual
            AND TiposBloqID!=DepGarantia
            AND NatTipoBloq IN('D','A')
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_DepGarantia) THEN

	    SELECT TiposBloqID, Descripcion FROM TIPOSBLOQUEOS
	        WHERE Estatus=Var_Activo
	            AND TipoMovimiento = Var_Manual AND TiposBloqID=DepGarantia;
	END IF;

	IF(Par_NumLis = Lis_DepGarFOGAFI) THEN

	    SELECT TiposBloqID, Descripcion FROM TIPOSBLOQUEOS
	        WHERE Estatus=Var_Activo
	            AND TipoMovimiento = Var_Manual AND TiposBloqID=DepGarFOGAFI;
	END IF;
END TerminaStore$$