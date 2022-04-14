-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LLENASPEITRANSFERENCIAS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LLENASPEITRANSFERENCIAS`;DELIMITER $$

CREATE PROCEDURE `LLENASPEITRANSFERENCIAS`(
	Par_NumClientes			INT,				-- Numero de Clientes que realizaran transferencias.
    Par_MontoMaximo			INT,				-- Monto maximo a depositar.
	Par_Salida				CHAR(1),			-- Tipo de Salida.
    INOUT Par_NumErr		INT(11),			-- Numero de Error.
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error.

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore:BEGIN
-- Declaracion de variables
DECLARE Salida_SI		CHAR(1);
DECLARE Cadena_Vacia 	CHAR(1);
DECLARE Est_Activo		CHAR(1);
DECLARE Var_Nombre		VARCHAR(200);
DECLARE Var_Clave		VARCHAR(18);
DECLARE Var_Monto		DECIMAL(16,2);
DECLARE Entero_UNO		INT(11);
DECLARE Entero_DOS		INT(11);
DECLARE Entero_Cero		INT(11);
DECLARE ReferenciaSP 	INT(11);
DECLARE Var_Control		VARCHAR(50);

DECLARE CursorClabes CURSOR FOR
SELECT C.NombreCompleto,CA.Clabe FROM CLIENTES C
INNER JOIN CUENTASAHO CA ON C.ClienteID=CA.ClienteID
WHERE C.Estatus=Est_Activo
	AND CA.Estatus=Est_Activo
	AND IFNULL(CA.Clabe,Cadena_Vacia)!=Cadena_Vacia
ORDER BY RAND() LIMIT Par_NumClientes;

-- Declaracion de Constantes
SET	Salida_SI			:= 'S';	-- El Store si regresa una Salida
SET Cadena_Vacia		:= '';	-- Valor para campos nulos
SET Est_Activo			:= 'A'; -- Valor para un estatus Activo
SET Entero_Cero			:= 0;   -- valor Entero 0
SET Entero_UNO			:= 1;	-- Valor entero 1
SET Entero_DOS			:= 2;	-- Valor entero 2
SET ReferenciaSP		:= 111111;
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr  := 999;
					SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-LLENASPEITRANSFERENCIAS');
					SET Var_Control := 'SQLEXCEPTION';
		END;
         OPEN CursorClabes;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
						FETCH CursorClabes INTO	Var_Nombre,Var_Clave;

                        SET Var_Monto := (select ROUND((RAND()*Par_MontoMaximo)+Entero_UNO,Entero_DOS));

                        CALL SPEITRANSFERENCIASALT(	Entero_Cero,		Var_Nombre,			Var_Clave,			Var_Monto,			ReferenciaSP,
													Par_Salida,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
                                                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				END LOOP CICLO;
			END;
		CLOSE CursorClabes;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := 'Transferencia SPEI Exitoso';
		SET Var_Control	:= 'speiTransID' ;
	END ManejoErrores;


IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr 		AS NumErr,
			Par_ErrMen	 	AS ErrMen,
			Var_Control 	AS Control;
END IF;
END TerminaStore$$