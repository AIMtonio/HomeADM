DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCARGAPOLIZASETLLIS`;
DELIMITER $$

CREATE PROCEDURE `TMPCARGAPOLIZASETLLIS`(
# =====================================================================================
# --- STORED PARA LISTAR LOS REGISTROS DE LA CARGA DE POLIZAS DEL ETL CargaPolizas ---
# =====================================================================================
    Par_NumTransaccion   	BIGINT(20), 	-- Numero de transaccion
    Par_NumLis      	TINYINT UNSIGNED, 	-- Numero de lista

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
  )
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia    CHAR(1);        		-- Cadena vacia
	DECLARE Fecha_Vacia     DATE;         			-- Fecha vacia
	DECLARE Entero_Cero     INT(1);           		-- Entero cero
	DECLARE Decimal_Cero    DECIMAL(14,2);    		-- decimal cero
	DECLARE Salida_SI       CHAR(1);          		-- Salida si

	DECLARE Salida_NO       CHAR(1);          		-- Salida no
	DECLARE Entero_Uno      INT(11);          		-- entero uno
	DECLARE Cons_NO         CHAR(1);          		-- Constante no
    DECLARE Grupo_Detalle   CHAR(1);      			-- Grupo detalle poliza D
    DECLARE Cons_SI			CHAR(1);      			-- Constante si

    DECLARE Grupo_Encabezado CHAR(1);      			-- Grupo encabezado poliza E
	DECLARE Lis_Exitosos	INT(11);				-- 1:Lista de registros exitosos
    DECLARE Lis_Fallidos	INT(11);				-- 2:Lista de registros fallidos

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Decimal_Cero      	:= 0.0;
	SET Salida_SI           := 'S';

	SET Salida_NO           := 'N';
	SET Entero_Uno          := 1;
	SET Cons_NO             := 'N';
	SET Grupo_Detalle     	:= 'D';
    SET Cons_SI				:= 'S';

	SET Grupo_Encabezado   	:= 'E';
	SET Lis_Exitosos		:= 1;
    SET Lis_Fallidos		:= 2;

    -- 1:Lista de registros exitosos
    IF(Par_NumLis = Lis_Exitosos)THEN
		SELECT	CuentaCompleta, CentroCostoID,	Referencia, DescripCtaCompleta, Cargos,
				Abonos, 		DescripPoliza,	DesPertenece
        FROM TMPCARGAPOLIZASETL
		WHERE NumTransaccion = Par_NumTransaccion
			AND EsExitoso = Cons_SI;
    END IF;

    -- 2:Lista de registros fallidos
    IF(Par_NumLis = Lis_Fallidos)THEN
		SELECT	CuentaCompleta, CentroCostoID,	Referencia, DescripCtaCompleta, Cargos,
				Abonos, 		DescripPoliza,			DesPertenece
        FROM TMPCARGAPOLIZASETL
        WHERE NumTransaccion = Par_NumTransaccion
			AND EsExitoso = Cons_NO;
    END IF;

END TerminaStore$$