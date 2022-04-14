-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBGRUPOSCREDITOWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBGRUPOSCREDITOWSALT`;DELIMITER $$

CREATE PROCEDURE `CRCBGRUPOSCREDITOWSALT`(
	-- === SP para realizar Alta de Grupos mediante el WS de Alta de Grupos de CREDICLUB =====
	Par_NombreGrupo			VARCHAR(200),	-- Nombre del Grupo
	Par_SucursalID			INT(11),		-- Numero de Sucursal
	Par_CicloActual			INT(11),		-- Ciclo Actual del Grupo

	Par_Salida				CHAR(1), 		-- Indica mensaje de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Descripcion de Error

	Par_EmpresaID		    INT(11),		-- Parametro de Auditoria
	Aud_Usuario			    INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		  	DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria

)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_GrupoID				INT(11);
    DECLARE	Fecha_REg				DATETIME;
	DECLARE	Var_NomGrupo			CHAR(200);
	DECLARE Var_EstatusCiclo		CHAR(1);
    DECLARE Var_EjecutaCierre		CHAR(1);		-- indica si se esta realizando el cierre de dia

	-- Declaracion de Constantes
	DECLARE Entero_Cero             INT(11);
    DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Decimal_Cero	        DECIMAL(12,2);
	DECLARE Fecha_Vacia             DATE;
    DECLARE SalidaSI                CHAR(1);

    DECLARE SalidaNO                CHAR(1);
    DECLARE SimbInterrogacion		VARCHAR(1);
    DECLARE EstatusNoIniciado		CHAR(1);
    DECLARE Est_Cerrado				CHAR(1);
    DECLARE Act_Inicia      		INT(11);
    DECLARE EsAgropecuario			CHAR(1);
    DECLARE ValorCierre				VARCHAR(30);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero	    :=  0.00;   			-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
    SET SalidaSI           	:= 'S';        			-- El Store SI genera una Salida

    SET	SalidaNO 	   	   	:= 'N';	      			-- El Store NO genera una Salida
    SET SimbInterrogacion	:= '?';					-- Simbolo de interrogacion
    SET EstatusNoIniciado	:= 'N';					-- Estatus Grupo: No Iniciado
    SET Est_Cerrado			:= 'C';					-- Estatus grupos cerrado
	SET Act_Inicia      	:= 1;              		-- Tipo de Actualizacion: Inicio del Ciclo
	SET EsAgropecuario		:= 'N';					-- No es credito agropecuario
	SET ValorCierre			:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBGRUPOSCREDITOWSALT');
			END;

        SET Par_NombreGrupo			:= REPLACE(Par_NombreGrupo, SimbInterrogacion, Cadena_Vacia);
		SET Par_SucursalID			:= REPLACE(Par_SucursalID, SimbInterrogacion, Entero_Cero);
        SET Par_CicloActual			:= REPLACE(Par_CicloActual, SimbInterrogacion, Entero_Cero);
        SET Aud_Usuario				:= REPLACE(Aud_Usuario, SimbInterrogacion, Entero_Cero);
		SET Aud_Sucursal			:= REPLACE(Aud_Sucursal, SimbInterrogacion, Entero_Cero);

		SET Par_NombreGrupo			:= UPPER(Par_NombreGrupo);

       -- Variable para que no se repitan el mismo nombre del grupo en la sucursal
		SET Var_NomGrupo := (SELECT NombreGrupo FROM GRUPOSCREDITO
							WHERE NombreGrupo   = Par_NombreGrupo
							AND SucursalID    = Par_SucursalID);

        -- Se obtiene el Numero de Empresa
		SET Par_EmpresaID := (SELECT EmpresaDefault FROM PARAMETROSSIS LIMIT 1);

        SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=SalidaSI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_CicloActual,Entero_Cero)) = Entero_Cero THEN
			SET Par_CicloActual = Entero_Cero;
            SET Var_EstatusCiclo := EstatusNoIniciado;

		ELSE
			SET Par_CicloActual = Par_CicloActual;
            SET Var_EstatusCiclo := Est_Cerrado;
        END IF;

		IF(IFNULL(Par_NombreGrupo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Nombre del Grupo esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_SucursalID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Sucursal esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_EstatusCiclo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 004;
			SET Par_ErrMen := 'El Estado del Ciclo esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Var_NomGrupo, Cadena_Vacia)) <> Cadena_Vacia THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := 'El Nombre ya Existe en esta Sucursal.';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT SucursalID FROM SUCURSALES
			WHERE SucursalID = Par_SucursalID)THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La Sucursal no Existe.';
			LEAVE ManejoErrores;
		END IF;

        IF(Aud_Usuario = Entero_Cero)THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen  := 'El Usuario esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT UsuarioID FROM USUARIOS
						WHERE UsuarioID = Aud_Usuario) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen  := 'El Usuario No Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(Aud_Sucursal = Entero_Cero)THEN
			SET Par_NumErr	:= 009;
			SET Par_ErrMen  := 'La Sucursal esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT SucursalID FROM SUCURSALES
						WHERE SucursalID = Aud_Sucursal) THEN
			SET Par_NumErr	:= 010;
			SET Par_ErrMen  := 'La Sucursal No Existe.';
			LEAVE ManejoErrores;
		END IF;

		SET Fecha_REg       := NOW();
		SET Aud_FechaActual := NOW();
		SET Var_GrupoID     := (SELECT IFNULL(MAX(GrupoID), 0) + 1	FROM GRUPOSCREDITO);

        -- Registro del Grupo en la tabla GRUPOSCREDITO
        INSERT INTO GRUPOSCREDITO (
			GrupoID,      		NombreGrupo,      	FechaRegistro,    	SucursalID,   		CicloActual,
			EstatusCiclo, 		FechaUltCiclo,    	CicloPonderado,   	EsAgropecuario,		TipoOperaAgro,
            EmpresaID,    		Usuario,			FechaActual,  		DireccionIP,     	ProgramaID,
            Sucursal,     		NumTransaccion)
		VALUES(
			Var_GrupoID,        Par_NombreGrupo,    Fecha_REg,      	Par_SucursalID, 	Par_CicloActual,
			Var_EstatusCiclo,   Fecha_Vacia,  		Entero_Cero,		EsAgropecuario,	    Cadena_Vacia,
            Par_EmpresaID,  	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,   	Aud_NumTransaccion);



		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := CONCAT("Grupo de Credito Agregado Exitosamente: ",Var_GrupoID);


    END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen     	AS mensajeRespuesta,
				Var_GrupoID  	AS grupoID;
	END IF;

END TerminaStore$$