DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCUENTASAHOLIS`;
DELIMITER $$

CREATE PROCEDURE `BANCUENTASAHOLIS`(


	Par_ClienteID			INT(11),
    Par_CuentaAhoID		    BIGINT(12),
    Par_TarjetaDebID	    VARCHAR(16),
    Par_Correo			    VARCHAR(100),
    Par_TelefonoCelular	    VARCHAR(100),

    Par_TamanioLista		INT(11),
	Par_PosicionInicial		INT(11),
	Par_NumLis				TINYINT UNSIGNED,

	Par_Empresa				INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_EstatusISR	CHAR(1);
	DECLARE Var_SumPenAct			DECIMAL(12,2);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Var_Sentencia 			VARCHAR(5000);			-- Consulta dinamica
	DECLARE Var_Where 				VARCHAR(2000);			-- Where dinamico


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Lis_CuetasCliente	INT(1);
	DECLARE Est_Activa			CHAR(1);
	DECLARE Est_Bloqueada		CHAR(1);
	DECLARE Lis_CuentaClabeCli	INT(1);
	DECLARE Lis_CuentasBancasCli  INT(1);
	DECLARE Lis_CuentasBancasDet INT(11);
	DECLARE Est_Reg				CHAR(1);
    DECLARE Var_Si          		CHAR(1);
	DECLARE	Est_CtaActiva			CHAR(1);

	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Lis_CuetasCliente		:= 1;
	SET Lis_CuentaClabeCli		:= 2;
	SET Lis_CuentasBancasCli    := 3;
	SET Lis_CuentasBancasDet	:= 4;
	SET Est_Activa				:= 'A';
	SET Est_Bloqueada			:= 'B';
	SET Est_Reg					:= 'R';

    SET Var_Si          			:= 'S';
    SET Decimal_Cero 				:=  0.00;
    SET	Est_CtaActiva				:= 'A';

    SET Par_CuentaAhoID		    := IFNULL(Par_CuentaAhoID, Entero_Cero);
    SET Par_TarjetaDebID	    := IFNULL(Par_TarjetaDebID, Cadena_Vacia);
    SET Par_Correo			    := IFNULL(Par_Correo, Cadena_Vacia);
    SET Par_TelefonoCelular	    := IFNULL(Par_TelefonoCelular, Cadena_Vacia);
    SET Par_ClienteID			:= IFNULL(Par_ClienteID, Entero_Cero);


	IF(Par_NumLis = Lis_CuetasCliente) THEN
		SELECT	AHO.CuentaAhoID,	TIP.TipoCuentaID,					TIP.Descripcion,		AHO.FechaApertura,			AHO.Saldo,
				AHO.SaldoDispon,	AHO.Etiqueta	AS Etiqueta
			FROM CUENTASAHO AHO
			INNER JOIN TIPOSCUENTAS TIP ON TIP.TipoCuentaID = AHO.TipoCuentaID
			WHERE AHO.ClienteID = Par_ClienteID
			AND AHO.Estatus IN (Est_Activa, Est_Bloqueada);
	END IF;

	IF(Par_NumLis = Lis_CuentaClabeCli) THEN
		SELECT	AHO.CuentaAhoID,	AHO.Clabe
			FROM CUENTASAHO AHO
			INNER JOIN TIPOSCUENTAS TIP ON TIP.TipoCuentaID = AHO.TipoCuentaID
			WHERE AHO.ClienteID = Par_ClienteID
			AND AHO.Estatus IN (Est_Activa, Est_Reg);
	END IF;

	IF(Par_NumLis = Lis_CuentasBancasCli) THEN


	SET Var_Sentencia := 'SELECT 	ca.CuentaAhoID,	        cli.NombreCompleto
			FROM CUENTASAHO ca
		        INNER JOIN CLIENTES cli 	ON ca.ClienteID 	= cli.ClienteID ';
		SET Var_Where := '';
		IF(Par_CuentaAhoID <> Entero_Cero) THEN
			SET Var_Where := CONCAT(' WHERE ca.CuentaAhoID = ', Par_CuentaAhoID, ' ');
		END IF;

		IF(Par_TelefonoCelular <> Cadena_Vacia) THEN
			SET Var_Where := CONCAT(' WHERE cli.TelefonoCelular = "', Par_TelefonoCelular, '" ');
		END IF;

		IF(Par_Correo <> Cadena_Vacia) THEN
			SET Var_Where := CONCAT(' WHERE cli.Correo = "', Par_Correo, '" ');
		END IF;

		IF(Par_TarjetaDebID <> Cadena_Vacia) THEN
			SET Var_Where := CONCAT(' INNER JOIN TARJETADEBITO TAR ON ca.CuentaAhoID = TAR.CuentaAhoID WHERE TAR.TarjetaDebID = ',Par_TarjetaDebID);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,Var_Where);

		SET @Var_Sentencia  = (Var_Sentencia);
		PREPARE SQLBANCUENTASAHOLIS FROM @Var_Sentencia;
		EXECUTE SQLBANCUENTASAHOLIS ;
		DEALLOCATE PREPARE SQLBANCUENTASAHOLIS;

	END IF;


	IF(Par_NumLis = Lis_CuentasBancasDet) THEN


			SET Var_Sentencia := 'SELECT 	ca.CuentaAhoID,		ca.Clabe,			ca.Etiqueta,	ca.Saldo,	ca.SaldoDispon,		ca.SaldoBloq,
											ca.SaldoSBC,			tip.Descripcion,	ca.CargosMes, 	ca.AbonosMes
									FROM CUENTASAHO ca
										INNER JOIN CLIENTES cli 	ON ca.ClienteID 	= cli.ClienteID
										LEFT JOIN TARJETADEBITO tar ON tar.CuentaAhoID = ca.CuentaAhoID
										INNER JOIN TIPOSCUENTAS tip ON ca.TipoCuentaID = tip.TipoCuentaID ';

		SET Var_Where := '';
		IF(Par_CuentaAhoID > Entero_Cero) THEN
			SET Var_Where := CONCAT('WHERE ca.CuentaAhoID = ', Par_CuentaAhoID, ' ');
		END IF;

		IF(Par_ClienteID > Entero_Cero) THEN
			IF(Var_Where = Cadena_Vacia) THEN
				SET Var_Where := CONCAT('WHERE ca.ClienteID = ', Par_ClienteID, ' ');
			ELSE
				SET Var_Where := CONCAT(Var_Where, 'AND ca.ClienteID = ', Par_ClienteID, ' ');
			END IF;
		END IF;

		IF(Var_Where = Cadena_Vacia) THEN
			SET Var_Where := CONCAT('WHERE ca.Estatus = "', Est_CtaActiva, '" ');
		ELSE
			SET Var_Where := CONCAT(Var_Where, 'AND ca.Estatus = "', Est_CtaActiva, '" ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, Var_Where);

		SET @Var_Sentencia  = (Var_Sentencia);
		PREPARE SQLBANCUENTASAHOLIS FROM @Var_Sentencia;
    	EXECUTE SQLBANCUENTASAHOLIS ;
    	DEALLOCATE PREPARE SQLBANCUENTASAHOLIS;

	END IF;



END TerminaStore$$
