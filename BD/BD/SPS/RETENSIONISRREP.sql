-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RETENSIONISRREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RETENSIONISRREP`;DELIMITER $$

CREATE PROCEDURE `RETENSIONISRREP`(

	Par_FechaInicial 		DATE,
	Par_FechaFinal			DATE,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore: BEGIN


DECLARE Var_FechaSistema    DATE;


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE ISR_Cuenta          INT;
DECLARE ISR_Inversion       INT;
DECLARE Var_InicioMes       DATE;
DECLARE EsInversion         INT;
DECLARE EsAhorro            INT;
DECLARE Entero_Cero			int;


SET Entero_Cero			:= 0;
SET Cadena_Vacia		:= '';
SET Fecha_Vacia     	:= '1900-01-01';
SET ISR_Cuenta      	:= 220;
SET ISR_Inversion   	:= 64;
SET EsAhorro        	:= 2;
SET EsInversion     	:= 13;
SET Var_FechaSistema 	:= '1900-01-01';
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Var_InicioMes		:= DATE_FORMAT(Var_FechaSistema, '%Y-%m-01');


DROP TABLE IF EXISTS TMPRETENCIONISRREP;
CREATE TABLE TMPRETENCIONISRREP
    (
        ClienteID           INT,
        NombreCompleto      VARCHAR(200),
        RFC                 VARCHAR(20),
        CURP                CHAR(20),
        MontoInversion      DECIMAL(12,2),
        Plazo               INT,
        MontoISR            DECIMAL(12,2),
        FechaInicio         DATE,
        FechaVencimiento    DATE
    );



 DROP TABLE IF EXISTS TMPRETENCIONES;
 CREATE TABLE TMPRETENCIONES

    (
        ClienteID           INT,
        TipoInstrumentoID   INT,
        Instrumento         BIGINT,
        Monto               DECIMAL(12,2),
        FechaInicio         DATE,
        FechaVencimiento    DATE,
        NumTransaccion      INT
    );
CREATE INDEX idxClienteID ON TMPRETENCIONES(ClienteID);
CREATE INDEX idxInstrumento ON TMPRETENCIONES(Instrumento);




 IF(Par_FechaInicial<Var_InicioMes)THEN

        INSERT INTO TMPRETENCIONES
        SELECT
                    cta.ClienteID,	EsAhorro,	   his.ReferenciaMov, 	 CantidadMov,
                    Fecha_Vacia,	Fecha,   his.NumTransaccion
            FROM `HIS-CUENAHOMOV` his,
                CUENTASAHO cta
            WHERE his.CuentaAhoID= cta.CuentaAhoID
            AND TipoMovAhoID =ISR_Cuenta
            AND his.fecha BETWEEN Par_FechaInicial  AND Par_FechaFinal;


     INSERT INTO TMPRETENCIONES
        SELECT cta.ClienteID,	EsInversion,       his.ReferenciaMov, 	     CantidadMov,
			   Fecha_Vacia,	    Fecha,             his.NumTransaccion
            FROM `HIS-CUENAHOMOV` his,
                CUENTASAHO cta
            WHERE his.CuentaAhoID= cta.CuentaAhoID
            AND TipoMovAhoID =ISR_Inversion
            AND his.fecha BETWEEN Par_FechaInicial  AND Par_FechaFinal;

 END IF;


IF (Par_FechaFinal>=Var_InicioMes)THEN
        INSERT INTO TMPRETENCIONES
		SELECT  cta.ClienteID,	EsAhorro,		movs.ReferenciaMov, 	 CantidadMov,
                Fecha_Vacia,	Fecha,    		movs.NumTransaccion
        FROM  CUENTASAHOMOV movs,
                CUENTASAHO cta
        WHERE movs.CuentaAhoID= cta.CuentaAhoID
        AND TipoMovAhoID =ISR_Cuenta
        AND movs.fecha BETWEEN Par_FechaInicial  AND Par_FechaFinal;


        INSERT INTO TMPRETENCIONES
            SELECT
                cta.ClienteID,	EsAhorro,		movs.ReferenciaMov, 	 CantidadMov,
                Fecha_Vacia,	Fecha,    movs.NumTransaccion
        FROM  CUENTASAHOMOV movs,
                CUENTASAHO cta
        WHERE movs.CuentaAhoID= cta.CuentaAhoID
        AND TipoMovAhoID =ISR_Inversion
        AND movs.fecha BETWEEN Par_FechaInicial  AND Par_FechaFinal;

END IF;



    INSERT INTO TMPRETENCIONISRREP
        SELECT  cli.ClienteID,      NombreCompleto,     RFC,            CURP,
                inv.Monto,          Plazo,              ret.Monto,      inv.FechaInicio,
                ret.FechaVencimiento
        FROM TMPRETENCIONES ret, CLIENTES cli , INVERSIONES inv
        WHERE ret.ClienteID=cli.ClienteID
        AND ret.Instrumento=inv.InversionID
        AND ret.TipoInstrumentoID=EsInversion;


        SELECT 	tmp.ClienteID, 			tmp.NombreCompleto,  			tmp.RFC,          						tmp.CURP,
				tmp.MontoInversion,     tmp.Plazo AS PlazoInversion,   	tmp.MontoISR AS InteresRetenido,       	NOW() AS HoraEmision,
				tmp.FechaInicio,        tmp.FechaVencimiento
        FROM TMPRETENCIONISRREP tmp
		ORDER BY tmp.Plazo DESC, tmp.FechaVencimiento DESC, tmp.ClienteID DESC;




END TerminaStore$$