-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRIMERDEPCTAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRIMERDEPCTAHOPRO`;DELIMITER $$

CREATE PROCEDURE `PRIMERDEPCTAHOPRO`(
	Par_CuentaAhoID			BIGINT(12),	-- Cuenta de Ahorro
	Par_FechaFin			DATE,		-- Fecha de Fin del Mes
    Par_Salida				CHAR(1),
OUT Par_NumErr				INT,
OUT Par_ErrMen				VARCHAR(200),

    Par_EmpresaID			INT(11),
    Aud_Usuario				INT(11),
    Aud_FechaActual			DATETIME,
    Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID			VARCHAR(50),
    Aud_Sucursal			INT,
    Aud_NumTransaccion		BIGINT
)
TerminaStore:BEGIN

DECLARE Var_Control				VARCHAR(50);


DECLARE Act_AplicaChequeSBC		INT;
DECLARE Act_CancelaChequeSBC	INT;
DECLARE Entero_Cero				INT;
DECLARE Cadena_Vacia			CHAR;
DECLARE Est_Aplicado			CHAR(1);

DECLARE Est_Cancelado			CHAR(1);
DECLARE SalidaSI				CHAR(1);
DECLARE Tipo_Migracion			INT;
DECLARE Tipo_Mensual			INT;
DECLARE Fecha_Vacia				DATE;

DECLARE Decimal_Cero			DECIMAL(12,2);



SET Act_AplicaChequeSBC		:=1;
SET Act_CancelaChequeSBC	:=2;
SET Entero_Cero				:=0;
SET Cadena_Vacia			:='';
SET Est_Cancelado			:='C';

SET Est_Aplicado			:='A';
SET SalidaSI				:='S';
SET Tipo_Migracion			:= 1;
SET Fecha_Vacia				:= '1900-01-01';
SET Tipo_Mensual			:= 2;

SET Decimal_Cero			:= 0.0;

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr 	:= 999;
			SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PRIMERDEPCTAHOPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;


		-- Fecha inicial de los depositos
        DROP TABLE IF EXISTS TMP_FECHADEPINICIAL;
		CREATE TEMPORARY TABLE TMP_FECHADEPINICIAL
		SELECT his.CuentaAhoID, MIN(his.FechaActual) Fecha
			FROM `HIS-CUENAHOMOV` his, CUENTASAHO cue
				WHERE his.CuentaAhoID = cue.CuentaAhoID
					AND his.Fecha <= Par_FechaFin
					AND cue.FechaDepInicial = Fecha_Vacia
					AND cue.MontoDepInicial = Decimal_Cero
					GROUP BY his.CuentaAhoID;

		-- filtramos los primeros depositos del cliente
		DROP TABLE IF EXISTS TMP_PRIMERDEPOSITO;
		CREATE TEMPORARY TABLE TMP_PRIMERDEPOSITO
		SELECT his.CuentaAhoID,his.CantidadMov, his.Fecha
			FROM `HIS-CUENAHOMOV` his,TMP_FECHADEPINICIAL tem
			WHERE his.CuentaAhoID = tem.CuentaAhoID
				AND his.FechaActual = tem.Fecha;

		CREATE INDEX idx_1 ON TMP_PRIMERDEPOSITO(CuentaAhoID);

		-- se actualizan en la cuenta
		UPDATE CUENTASAHO cue,TMP_PRIMERDEPOSITO tem
		  SET cue.MontoDepInicial = tem.CantidadMov,
				cue.FechaDepInicial = tem.Fecha
		WHERE cue.CuentaAhoID = tem.CuentaAhoID;


		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Calculo del Primer Deposito Exitoso';

END ManejoErrores;

	IF (IFNULL(Par_Salida,Cadena_Vacia) = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$