-- APPWCUENTASAHOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS APPWCUENTASAHOLIS;

DELIMITER $$

CREATE PROCEDURE `APPWCUENTASAHOLIS`(

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
	SET	Lis_CuentaClabeCli		:= 1;
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

IF(Par_NumLis = Lis_CuentaClabeCli) THEN


	SET Var_Sentencia := 'SELECT 	ca.CuentaAhoID,	        cli.NombreCompleto, Clabe
			FROM CUENTASAHO ca
		        INNER JOIN CLIENTES cli 	ON ca.ClienteID 	= cli.ClienteID ';
		SET Var_Where := '';
		IF(Par_CuentaAhoID <> Entero_Cero) THEN
			SET Var_Where := CONCAT(' WHERE ca.CuentaAhoID = ', Par_CuentaAhoID, ' ');
		END IF;

		IF(Par_TelefonoCelular <> Cadena_Vacia) THEN
			SET Var_Where := CONCAT(' WHERE ca.TelefonoCelular = "', Par_TelefonoCelular, '" ');
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


END TerminaStore$$
