-- SP TIPOEMPLEADOSCONVENIOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS TIPOEMPLEADOSCONVENIOLIS;

DELIMITER $$

CREATE PROCEDURE TIPOEMPLEADOSCONVENIOLIS (
# ===============================================================
# ----- STORE PARA LA LISTA DE TIPO EMPLEADOS CONVENIO -----
# ===============================================================
	Par_InstitNominaID		INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    BIGINT UNSIGNED,			-- Numero de Convenio Nomina
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

	Par_EmpresaID       	INT(11),			-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de Auditoria Numero de la Transaccion
		)
TerminaStore:BEGIN

    -- Declaracion de Variables

	-- Declaracion de Constantes
	DECLARE Entero_Cero    		INT(11);		-- Entero Cero
    DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
	DECLARE Cadena_Vacia   		CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;			-- Fecha Vacia
    DECLARE ConstanteSI			CHAR(1);		-- Constante: SI
	DECLARE EstNoSelec			CHAR(1);		-- Estatus No Seleccionado
    DECLARE Estatus_Activo		CHAR(1);	-- Estatus del Tipo de Empleado (A = Activo, I = INactivo)


	DECLARE Lis_Principal		INT(11);		-- Lista principal
    DECLARE Lis_ComboTiposEmp	INT(11);		-- Lista Combo tipos empleados
    DECLARE Lis_TiposEmpConvNom	INT(11);		-- Lista de Tipos de Empleados por Convenio de Nomina

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 			-- Entero Cero
    SET Decimal_Cero        := 0.00;		-- Decimal Cero
	SET Cadena_Vacia		:= '';    		-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha Vacia
    SET ConstanteSI			:= 'S';			-- Constante: SI
    SET Lis_Principal		:= 1;			-- Lista principal
    SET Lis_ComboTiposEmp	:= 2;			-- Lista Combo tipos empleados
	SET Lis_TiposEmpConvNom	:= 3;			-- Lista de Tipos de Empleados por Convenio de Nomina
    SET EstNoSelec			:= 'N';
    SET Estatus_Activo		:= 'A';

    -- 1.- Lista de Tipo Empleados Convenios
	IF(Par_NumLis = Lis_Principal)THEN
    
		SELECT  CTP.TipoEmpleadoID,	CTP.Descripcion, IFNULL(TP.SinTratamiento,Cadena_Vacia) AS SinTratamiento ,
        IFNULL(TP.ConTratamiento,Cadena_Vacia) AS ConTratamiento,IFNULL(TP.EstatusCheck,EstNoSelec) AS EstatusCheck
        FROM CATTIPOEMPLEADOS  CTP LEFT JOIN TIPOEMPLEADOSCONVENIO TP 
        ON CTP.TipoEmpleadoID = TP.TipoEmpleadoID 
        AND TP.InstitNominaID = Par_InstitNominaID
        AND TP.ConvenioNominaID = Par_ConvenioNominaID WHERE Estatus = Estatus_Activo;
        
    END IF;
    
    -- 1.- Lista de Tipo Empleados Convenios
	IF(Par_NumLis = Lis_ComboTiposEmp)THEN
    
		SELECT  CTP.TipoEmpleadoID,	CTP.Descripcion, IFNULL(TP.SinTratamiento,Cadena_Vacia) AS SinTratamiento ,
				IFNULL(TP.ConTratamiento,Cadena_Vacia) AS ConTratamiento,IFNULL(TP.EstatusCheck,EstNoSelec) AS EstatusCheck
        FROM CATTIPOEMPLEADOS  CTP 
        INNER JOIN TIPOEMPLEADOSCONVENIO TP  ON CTP.TipoEmpleadoID = TP.TipoEmpleadoID 
        WHERE TP.EstatusCheck="S"
          AND TP.InstitNominaID = Par_InstitNominaID 
          AND TP.ConvenioNominaID = Par_ConvenioNominaID;
        
    END IF;
    
     -- 3.- Lista de Tipos de Empleados por Convenio de Nomina
	IF(Par_NumLis = Lis_TiposEmpConvNom)THEN
		SELECT  CTP.TipoEmpleadoID,	CTP.Descripcion
        FROM TIPOEMPLEADOSCONVENIO TP
        INNER JOIN CATTIPOEMPLEADOS CTP
        ON TP.TipoEmpleadoID = CTP.TipoEmpleadoID
        WHERE TP.InstitNominaID = Par_InstitNominaID 
          AND TP.ConvenioNominaID = Par_ConvenioNominaID
          AND CTP.Estatus = Estatus_Activo
          ORDER BY TP.TipoEmpleadoID ASC;
        
    END IF;


END TerminaStore$$
