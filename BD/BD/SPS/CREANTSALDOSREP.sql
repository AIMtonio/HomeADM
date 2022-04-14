-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREANTSALDOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREANTSALDOSREP`;
DELIMITER $$


CREATE PROCEDURE `CREANTSALDOSREP`(
	Par_Fecha           DATE,
	Par_Sucursal        INT(11),
	Par_Moneda          INT,
	Par_ProductoCre     INT,
	Par_Promotor        INT,

	Par_Genero          CHAR(1),
	Par_Estado          INT,
	Par_Municipio       INT,
	Par_AtrasoInicial   		INT,
	Par_AtrasoFinal   		INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),

    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN


DECLARE Var_Sentencia 	VARCHAR(10000);


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Var_PerFisica    CHAR(1);
DECLARE VarPerFisicaActEmp    CHAR(1);
DECLARE VarDiasGracia    INT;


SET Cadena_Vacia	:= '';
SET Fecha_Vacia		:= '1900-01-01';
SET Entero_Cero		:= 0;
SET Var_PerFisica		:= 'F';
SET VarPerFisicaActEmp		:= 'A';



SET VarDiasGracia := (SELECT GraciaFaltaPago FROM PRODUCTOSCREDITO WHERE ProducCreditoID= Par_ProductoCre);
SET VarDiasGracia := VarDiasGracia-1;
CALL TRANSACCIONESPRO (Aud_NumTransaccion);


DROP TABLE IF EXISTS tmp_TMPCREANTSALDOSREP;
CREATE TEMPORARY TABLE tmp_TMPCREANTSALDOSREP (
		Transaccion		BIGINT,
		Credito			BIGINT(12),
		Cliente			INT(12),
		NomCliente		VARCHAR(200),
		MontoOriginal		DECIMAL(14,2),
		FechaIni			DATE,
		FechaVencim		DATE,
		TotCap			DECIMAL(14,2),
		CapVig			DECIMAL(14,2),
		CapVen			DECIMAL(14,2),
		ProdCredID		INT(12),
		NombrePromotor	VARCHAR(100),
		PromotorID		INT(12),
		NombreSucursal	VARCHAR(50),
		SucursalID		INT(12),
		ProductoCreID		INT(12),
		NombreProducto	VARCHAR(100),
		Bucket1			DECIMAL(14,2),
		Bucket2			DECIMAL(14,2),
		Bucket3			DECIMAL(14,2),
		Bucket4			DECIMAL(14,2),
		Bucket5			DECIMAL(14,2),
		Bucket6			DECIMAL(14,2),
		Bucket7			DECIMAL(14,2),
		Bucket8			DECIMAL(14,2),
		Bucket9			DECIMAL(14,2),
		MaxDiaAtr			INT(12),
		FechaEmision		DATE,
		HoraEmision		TIME,
        INDEX(Transaccion, Credito, Cliente)
	);
SET Var_Sentencia := '
INSERT INTO tmp_TMPCREANTSALDOSREP (
	Transaccion,
	Credito,
	Cliente,
	NomCliente,
	MontoOriginal,
	FechaIni,
	FechaVencim,
	TotCap,
	CapVig,
	CapVen,
	ProdCredID,
	NombrePromotor,
	PromotorID,
	NombreSucursal,
	SucursalID,
	ProductoCreID,
	NombreProducto,
	Bucket1,
	Bucket2,
	Bucket3,
	Bucket4,
	Bucket5,
	Bucket6,
	Bucket7,
	Bucket8,
	Bucket9,
	MaxDiaAtr,
	FechaEmision,
	HoraEmision)
';




SET Var_Sentencia :=  CONCAT(Var_Sentencia,'select
						convert("',Aud_NumTransaccion,'",unsigned int),
						Cre.CreditoID as Credito, max(Cre.ClienteID) as Cliente,
                              max(Cli.NombreCompleto) as NomCliente, max(Cre.MontoCredito) as MontoOriginal,
                              max(Cre.FechaInicio) as FechaIni, max(Cre.FechaVencimien) as FechaVencim,
                             (max(Cre.SaldoCapVigent) + max(Cre.SaldoCapAtrasad) +
                              max(Cre.SaldoCapVencido) + max(Cre.SaldCapVenNoExi)) as TotCap,
                             (max(Cre.SaldoCapVigent)) as CapVig,
                             (max(Cre.SaldoCapAtrasad) + max(Cre.SaldoCapVencido) +
                              max(Cre.SaldCapVenNoExi)) as CapVen,
                              max(Cre.ProductoCreditoID) as ProdCredID,
                              max(Prom.NombrePromotor) as NombrePromotor,
                              max(Prom.PromotorID) as PromotorID,
                              max(Suc.NombreSucurs) as NombreSucursal,
                              max(Suc.SucursalID) as SucursalID,
                              max(Pro.ProducCreditoID) as ProductoCreID,
                              max(Pro.Descripcion) as NombreProducto,

                            sum(CASE WHEN ( Amo.FechaExigible < Par.FechaSistema
                                        and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema,FUNCIONDIAHABIL(Amo.FechaExigible,GraciaMoratorios,', Par_EmpresaID,')) >= 1
                                        and datediff(Par.FechaSistema,  FUNCIONDIAHABIL(Amo.FechaExigible,GraciaMoratorios,', Par_EmpresaID,')) <= 29)
                                 THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                       Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
								ELSE 0.00
                                END ) as Bucket1,

                           sum(CASE WHEN ( Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus !="',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 30
                                  and datediff(Par.FechaSistema, Amo.FechaExigible) <= 59)
                                THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                      Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                ELSE 0.00
                                END ) as Bucket2,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 60
                                  and datediff(Par.FechaSistema, Amo.FechaExigible) <= 89)
                                      THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                            Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                       ELSE 0.00
                                 END ) as Bucket3,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P', '"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 90
                                   and datediff(Par.FechaSistema, Amo.FechaExigible) <= 119)
                                    THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                          Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                    ELSE 0.00
                                 END ) as Bucket4,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 120
                                  and datediff(Par.FechaSistema, Amo.FechaExigible) <= 149)
                                    THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                          Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                    ELSE 0.00
                                    END ) as Bucket5,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 150
                                  and datediff(Par.FechaSistema, Amo.FechaExigible) <= 179)
                                    THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                          Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                    ELSE 0.00
                                    END ) as Bucket6,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 180
                                  and datediff(Par.FechaSistema, Amo.FechaExigible) <= 269)
                                    THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                          Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                    ELSE 0.00
                                    END ) as Bucket7,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 270
                                  and datediff(Par.FechaSistema, Amo.FechaExigible) <= 364)
                                    THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                          Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                    ELSE 0.00
                                    END ) as Bucket8,
                            sum(CASE WHEN (Amo.FechaExigible < Par.FechaSistema
                                       and Amo.Estatus != "',
                            'P','"and datediff(Par.FechaSistema, Amo.FechaExigible) >= 365)
                                    THEN (Amo.SaldoCapVigente + Amo.SaldoCapAtrasa +
                                          Amo.SaldoCapVencido + Amo.SaldoCapVenNExi )
                                    ELSE 0.00
                                    END ) as Bucket9');


SET Var_Sentencia :=  CONCAT(Var_Sentencia,
                             ',  FUNCIONDIASATRASO( Cre.CreditoID, Par.FechaSistema) as MaxDiaAtr,Par.FechaSistema as FechaEmision, time(now()) as HoraEmision
                                from CREDITOS Cre,
                                     AMORTICREDITO Amo,
                                     CLIENTES Cli,
                                     PROMOTORES Prom,
                                     PARAMETROSSIS Par,
                                     SUCURSALES Suc,
                                     PRODUCTOSCREDITO Pro
                                where Cre.ClienteID = Cli.ClienteID
                                  and Cre.CreditoID = Amo.CreditoID
                                  and Cli.PromotorActual = Prom.PromotorID
                                  and Suc.SucursalID = Cre.SucursalID
                                  and Pro.ProducCreditoID = Cre.ProductoCreditoID
                                  and ( Cre.Estatus = "',
                              'V','"or   Cre.Estatus = "',
                              'B','"or   Cre.Estatus = "',
                              'K','"or   Cre.Estatus = "',
							   'S','") ');


SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
SET Par_Genero      := IFNULL(Par_Genero,Cadena_Vacia);
SET Par_Estado      := IFNULL(Par_Estado,Entero_Cero);
SET Par_Municipio   := IFNULL(Par_Municipio,Entero_Cero);
SET Par_Promotor    := IFNULL(Par_Promotor,Entero_Cero);
SET Par_Moneda      := IFNULL(Par_Moneda,Entero_Cero);
SET Par_Sucursal    := IFNULL(Par_Sucursal,Entero_Cero);


IF(Par_ProductoCre != 0)THEN
    SET Var_Sentencia :=  CONCAT(Var_sentencia,' and Pro.ProducCreditoID =',CONVERT(Par_ProductoCre,CHAR));
END IF;

IF(Par_Genero!=Cadena_Vacia)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' and Cli.Sexo="',Par_Genero,'"');
    SET Var_Sentencia := CONCAT(Var_sentencia,' and (Cli.TipoPersona="',Var_PerFisica,'" or  Cli.TipoPersona=" ',VarPerFisicaActEmp,'" )');
END IF;

IF(Par_Estado!=0)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.EstadoID from DIRECCLIENTE Dir where Dir.Oficial= "S" and Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Estado,CHAR));
END IF;

IF(Par_Municipio!=0)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' and (select Dir.MunicipioID from DIRECCLIENTE Dir where Dir.Oficial= "S" and Cre.ClienteID=Dir.ClienteID)=',CONVERT(Par_Municipio,CHAR));
END IF;

IF(Par_Promotor!=0)THEN
    SET Var_Sentencia := CONCAT(Var_sentencia,' and Prom.PromotorID=',CONVERT(Par_Promotor,CHAR));
END IF;

IF(Par_Moneda!=0)THEN
    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.MonedaID=',CONVERT(Par_Moneda,CHAR));
END IF;

IF(Par_Sucursal != 0)THEN
    SET Var_Sentencia = CONCAT(Var_sentencia,' and Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
END IF;

SET Var_Sentencia :=  CONCAT(Var_sentencia, ' group by Cre.CreditoID, Par.FechaSistema');
SET Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Cre.SucursalID, Cre.ProductoCreditoID, Cli.PromotorActual,Cre.CreditoID,Cre.FechaVencimien;');

SET @Sentencia	= (Var_Sentencia);

PREPARE STCREANTSALDOSREP FROM @Sentencia;
EXECUTE STCREANTSALDOSREP;
DEALLOCATE PREPARE STCREANTSALDOSREP;

SELECT
	Credito,
	Cliente,
	NomCliente,
	MontoOriginal,
	FechaIni,
	FechaVencim,
	TotCap,
	CapVig,
	CapVen,
	ProdCredID,
	NombrePromotor,
	PromotorID,
	NombreSucursal,
	SucursalID,
	ProductoCreID,
	NombreProducto,
	IFNULL(Bucket1, Entero_Cero) AS Bucket1,
  IFNULL(Bucket2, Entero_Cero) AS Bucket2,
  IFNULL(Bucket3, Entero_Cero) AS Bucket3,
  IFNULL(Bucket4, Entero_Cero) AS Bucket4,
  IFNULL(Bucket5, Entero_Cero) AS Bucket5,
  IFNULL(Bucket6, Entero_Cero) AS Bucket6,
  IFNULL(Bucket7, Entero_Cero) AS Bucket7,
  IFNULL(Bucket8, Entero_Cero) AS Bucket8,
  IFNULL(Bucket9, Entero_Cero) AS Bucket9,
	MaxDiaAtr,
	FechaEmision,
	HoraEmision
	FROM tmp_TMPCREANTSALDOSREP WHERE Transaccion = Aud_NumTransaccion
	AND MaxDiaAtr >= Par_AtrasoInicial
	AND MaxDiaAtr <=Par_AtrasoFinal;
DROP TABLE tmp_TMPCREANTSALDOSREP;
END TerminaStore$$