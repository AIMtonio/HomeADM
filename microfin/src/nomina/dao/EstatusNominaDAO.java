package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

 
import org.springframework.jdbc.core.RowMapper;


import nomina.bean.EmpleadoNominaBean;

import nomina.bean.PagoNominaBean;

public class EstatusNominaDAO extends BaseDAO{
	public EstatusNominaDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	/* Alta de Pagos de Nomina en PAGOSNOMINA */
	public List listaEstatEmpleados(int tipoLista, final EmpleadoNominaBean nominaBean){
		String query = "call NOMBITACOESTEMPLIS(?,?,?,?,?,?, ?,?,?,?,?,?,?);";//mapeo de los campos
		Object[] parametros = {	
				Utileria.convierteEntero(nominaBean.getInstitNominaID()),
				tipoLista,
				Utileria.convierteFecha(nominaBean.getFechaInicio()),
				Utileria.convierteFecha(nominaBean.getFechaFin()),
				Utileria.convierteEntero(nominaBean.getClienteID()),
				nominaBean.getEstatusEmp(),
			
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMBITACOESTEMPLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EmpleadoNominaBean nominaBean = new EmpleadoNominaBean();
				nominaBean.setNombreInstNomina(resultSet.getString("NombreInstit"));//aqui me quedé
				nominaBean.setFechaAct(resultSet.getString("Fecha"));
				nominaBean.setClienteID(resultSet.getString("ClienteID"));
				nominaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				nominaBean.setEstatusAnterior(resultSet.getString("EstatusAnterior"));
				nominaBean.setEstatusEmp(resultSet.getString("EstatusNuevo"));
				nominaBean.setFechaInicialInca((resultSet.getString("FechaInicioIncapacidad")));
				nominaBean.setFechaFinInca((resultSet.getString("FechaFinIncapacidad")));
				nominaBean.setFechaBaja((resultSet.getString("FechaBaja")));
				nominaBean.setMotivoBaja((resultSet.getString("MotivoBaja")));
				nominaBean.setHoraEmision((resultSet.getString("HoraEmision")));
				return nominaBean;
				
				
			}
		});
		return matches;
	}

}
