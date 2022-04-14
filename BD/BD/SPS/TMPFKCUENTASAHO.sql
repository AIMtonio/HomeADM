-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFKCUENTASAHO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPFKCUENTASAHO`;



Par_DB  varchar(255)
)


SET Par_DB = LTRIM(RTRIM(Par_DB));
DROP TABLE IF EXISTS TMPFK;

CREATE TEMPORARY TABLE TMPFK(
Tabla varchar(255),
FKNAME varchar(255));


INSERT INTO TMPFK VALUES ('PAGARECREDITO','fk_PAGARECREDITO_3');
INSERT INTO TMPFK VALUES ('AMORTICREDITO','fk_AMORTICREDITO_3');
INSERT INTO TMPFK VALUES ('BITACORACOBAUT','fk_BITACORACOBAUT_2');
INSERT INTO TMPFK VALUES ('CREDITODEVGL','fk_CREDITODEVGL_2');
INSERT INTO TMPFK VALUES ('CREDITOS','fk_CuentaID');
INSERT INTO TMPFK VALUES ('LINEASCREDITO','fk_LINEASCREDITO_2');
INSERT INTO TMPFK VALUES ('PARAMETROSSIS','fk_cuenta');
INSERT INTO TMPFK VALUES ('TESOLAYOUTCARGA','fk_TESOLAYOUTCARGA_1');
INSERT INTO TMPFK VALUES ('CLIAPROTECCUEN','fk_CLIAPROTECCUEN_2');
INSERT INTO TMPFK VALUES ('COBROSPEND','fk_COBROSPEND_3');
INSERT INTO TMPFK VALUES ('CONOCIMIENTOCTA','fk_CONOCIMIENTOCTA_1');
INSERT INTO TMPFK VALUES ('CUENTAARCHIVOS','fk_CUENTAARCHIVOS_1');
INSERT INTO TMPFK VALUES ('CUENTASAHOMOV','fk_CUENTASAHOMOV_1');
INSERT INTO TMPFK VALUES ('CUENTASAHOTESO','fk_CUENTASAHOTESO_8');
INSERT INTO TMPFK VALUES ('CUENTASFIRMA','fk_CUENTASFIRMA_1');
INSERT INTO TMPFK VALUES ('CUENTASPERSONA','fk_CUENTASPERSONA_1');
INSERT INTO TMPFK VALUES ('FONDEOKUBO','FK_CUENTA_AHO');
INSERT INTO TMPFK VALUES ('FONDEOSOLICITUD','FK_FONDEOSOLICITUD_CTA');
INSERT INTO TMPFK VALUES ('HISINVERSIONES','fk_HISINVERSIONES_2');
INSERT INTO TMPFK VALUES ('INVERSIONES','FK_CUENTA_INVERSION');
INSERT INTO TMPFK VALUES ('PROTECCIONESCTA','FK_CuentaAhoID_2');
INSERT INTO TMPFK VALUES ('SOLICITUDTARDEB','CuentaAhoID');
INSERT INTO TMPFK VALUES ('CLIAPOYOPROFUNBEN','fk_CLIAPOYOPROFUNBEN_1');
INSERT INTO TMPFK VALUES ('TESOMOVSCONCILIA','fk_TESOMOVSCONCILIA_1');


SELECT TABLE_NAME, COLUMN_NAME,CONSTRAINT_NAME, REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
  FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE KCU
  WHERE TABLE_SCHEMA = Par_DB
    AND REFERENCED_TABLE_NAME = 'CUENTASAHO'
    AND NOT EXISTS (SELECT * FROM TMPFK
          WHERE TABLA = KCU.TABLE_NAME
            AND FKNAME = KCU.CONSTRAINT_NAME);


DROP TABLE TMPFK;

END TerminaStore$$