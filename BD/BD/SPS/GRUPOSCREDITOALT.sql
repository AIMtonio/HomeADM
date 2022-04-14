-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSCREDITOALT`;
DELIMITER $$


CREATE PROCEDURE `GRUPOSCREDITOALT`(
/* SP QUE REALIZA EL ALTA DE UN GRUPO DE CREDITO*/
	Par_NombreGrupo		VARCHAR(200),		-- Se indica el nombre del grupo
	Par_SucursalID		INT(11),			-- Numero de sucursal
	Par_CicloActual		INT(11),			-- ciclo actual del grupo
	Par_EstatusCiclo	CHAR(1),			-- estatus del grupo
	Par_FechaUltCiclo	DATE,				-- fecha del ultimo ciclo

    Par_EsAgro			CHAR(1),			-- Indica si si se trata de un grupo Agro
    Par_TipoOpeAgro		CHAR(2),			-- Tipo de operacion para grupos agro: G: GLOBAL N: NO FORMAL

	Par_Salida       	CHAR(1),
	INOUT Par_NumErr 	INT(11),
	INOUT Par_ErrMen 	VARCHAR(400),

	Aud_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE	Var_GrupoID		INT(10);
	DECLARE	Var_NomGrupo	CHAR(200);
	DECLARE	Var_Control   	VARCHAR(100);
	-- Declaracion de Constantes
	DECLARE Entero_Cero 	INT;
	DECLARE Cad_Vacia 		CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE	SalidaSI     	CHAR(1);
	DECLARE	SalidaNO     	CHAR(1);
	DECLARE	Fecha_REg		DATETIME;
    DECLARE Es_Agropecuario CHAR(1);
	DECLARE Var_FechaSistema		DATE;		-- Fecha del sistema
	DECLARE Var_FechaSistemaHora	DATETIME;	-- Fecha del sistema con Hora

	-- Asignacion de Constantes
	SET Entero_Cero     := 0;
	SET Cad_Vacia       := '';
	SET Fecha_Vacia     := '1900-01-01';
	SET SalidaSI        := 'S';
	SET SalidaNO        := 'N';
    SET Es_Agropecuario := 'S';
	SET Var_FechaSistema 	 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FechaSistemaHora	:= CONCAT(Var_FechaSistema,' ',SUBSTRING(NOW(),12));

ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-GRUPOSCREDITOALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

	-- Variable para que no se repitan el mismo nombre del grupo en la sucursal
	SET Var_NomGrupo := (SELECT NombreGrupo FROM GRUPOSCREDITO
							WHERE NombreGrupo   = Par_NombreGrupo
							  AND SucursalID    = Par_SucursalID );

	IF(IFNULL(Par_NombreGrupo, Cad_Vacia)) = Cad_Vacia THEN
		SET Par_NumErr :='001';
		SET Par_ErrMen := 'El nombre del Grupo esta vacio.';
		SET Var_Control := 'nombreGrupo' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_SucursalID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := '002';
		SET Par_ErrMen := 'La Sucursal esta vacia.';
		SET Var_Control := 'sucursalID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstatusCiclo, Cad_Vacia)) = Cad_Vacia THEN
		SET Par_NumErr := '004';
		SET Par_ErrMen := 'El Estado del Ciclo esta vacio.';
		SET Var_Control := 'estatusCiclo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_NomGrupo, Cad_Vacia)) <> Cad_Vacia THEN
		SET Par_NumErr := '005';
		SET Par_ErrMen := 'El Nombre ya Existe en esta Sucursal.';
		SET Var_Control := 'nombreGrupo';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_EsAgro, Cad_Vacia)=Es_Agropecuario)THEN
		IF(IFNULL(Par_TipoOpeAgro,Cad_Vacia)=Cad_Vacia)THEN
			SET Par_NumErr := '006';
			SET Par_ErrMen := 'El Tipo de Operacion esta Vacio.';
			SET Var_Control := 'tipoOperacion';
			LEAVE ManejoErrores;
		END IF;
    END IF;

	SET Fecha_REg       := CURRENT_TIMESTAMP();
	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	SET Var_GrupoID     := (SELECT IFNULL(MAX(GrupoID), Entero_Cero) + 1 FROM GRUPOSCREDITO);

	INSERT INTO GRUPOSCREDITO (
		GrupoID,      NombreGrupo,      			FechaRegistro,    		SucursalID,   		CicloActual,
		EstatusCiclo, FechaUltCiclo,    			CicloPonderado,   		EsAgropecuario,		TipoOperaAgro,
        EmpresaID,    Usuario,						FechaActual,  			DireccionIP,  		ProgramaID,
        Sucursal,     NumTransaccion)
	VALUES(
		Var_GrupoID,        Par_NombreGrupo,    	Var_FechaSistemaHora,   Par_SucursalID, 	Par_CicloActual,
		Par_EstatusCiclo,   Par_FechaUltCiclo,  	Entero_Cero,    		Par_EsAgro,			Par_TipoOpeAgro,
        Aud_EmpresaID,  	Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,   	Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Grupo de Credito Agregado: ',Var_GrupoID);
    SET Var_Control:= 'grupoID';

END ManejoErrores;  -- End del Handler de Errores

 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
			Var_GrupoID AS consecutivo;
END IF;

END TerminaStore$$