-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAACCESANALISTAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAACCESANALISTAALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORAACCESANALISTAALT`(
# ======================================================
# ------- STORE PARA GUARDAR LOS ACCESOS DE ANALISTAS DE CREDITO----------
# ======================================================
    Par_UsuarioID           INT(11),        -- ID del usuario analista
    Par_Estatus             CHAR(1),  	    -- Estatus del usuario analista

	Par_Salida              CHAR(1),	    -- Salida S:SI  N:NO

	INOUT Par_NumErr        INT(11),		-- Numero de Error
	INOUT Par_ErrMen        VARCHAR(400),   -- Mensaje de Error
		-- Parametros de Auditoria
    Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
    Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables

	DECLARE		ConsecutivoID   BIGINT(20);      -- ID consecutvo
    DECLARE 	Var_Control		VARCHAR(100);	 -- Control de Retorno en pantalla
    DECLARE 	Var_Hora		TIME;	         -- Control de Retorno en pantalla
	DECLARE     Var_FechaSis    DATE;            -- Fecha del sistema
    DECLARE     Var_UsuarioA    INT(11);         -- ID usuario analista


	-- Declaracion de Constantes
	DECLARE		Cadena_Vacia	CHAR(1);	-- cadena vacia
	DECLARE		Fecha_Vacia		DATE;		-- fecha vacia
	DECLARE		Entero_Cero		INT(11);	-- entero en cero
    DECLARE 	Salida_SI 		CHAR(1);	-- Salida SI

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET Var_Control		:= '';
	SET Salida_SI		:= 'S';


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORAACCESANALISTAALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		-- Asignacion de Variables
		SET	ConsecutivoID	:= 0;
        
        	    -- Valida al usuario
  		IF(IFNULL(Par_UsuarioID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'Estatus vacio.';
			SET Var_Control	:= 'usuarioID';

			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Estatus,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Estatus vacio.';
			SET Var_Control	:= 'estatus';

			LEAVE ManejoErrores;
		END IF;
       
        SET Var_UsuarioA:=(SELECT U.UsuarioID FROM ROLES R INNER JOIN USUARIOS U WHERE R.RolID=U.RolID AND U.UsuarioID=Par_UsuarioID LIMIT 1);

        IF(IFNULL(Var_UsuarioA,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 003;
			SET Par_ErrMen  := 'Usuario no analista';
			SET Var_Control	:= 'usuarioID';

			LEAVE ManejoErrores;
		END IF;
		
		SET ConsecutivoID := (SELECT IFNULL(MAX(BitacoraAccesAID),Entero_Cero) + 1  FROM BITACORAACCESANALISTA);

        SET Var_Hora:= (SELECT DATE_FORMAT(NOW( ), "%H:%i:%S" ));
        SET Var_FechaSis:=(SELECT FechaSistema FROM PARAMETROSSIS);

		INSERT INTO BITACORAACCESANALISTA (
			BitacoraAccesAID,	        UsuarioID,                  Estatus,		            HoraActualizacion,              Fecha,                
            EmpresaID,                  Usuario,					FechaActual,			    DireccionIP,	   	            ProgramaID,		                
            Sucursal,                   NumTransaccion		)
		VALUES(
			ConsecutivoID,				Var_UsuarioA,	            Par_Estatus,                Var_Hora,                       Var_FechaSis ,
            Aud_EmpresaID,		        Aud_Usuario,		    	Aud_FechaActual,			Aud_DireccionIP,                Aud_ProgramaID,			        
            Aud_Sucursal,			    Aud_NumTransaccion	);


		SET	Par_NumErr := Entero_Cero;
	    SET	Par_ErrMen := 'Estatus Grabado Exitosamente.';
	    SET Var_Control:= 'usuarioID';


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			ConsecutivoID AS Consecutivo;
	END IF;

END TerminaStore$$