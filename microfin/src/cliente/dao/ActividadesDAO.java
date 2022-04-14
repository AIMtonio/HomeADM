package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.sql.DataSource;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import groovy.util.logging.Log4j;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.ActividadesBMXBean;
import cliente.bean.ActividadesCompletaBean;
import cliente.bean.ActividadesINEGIBean;
import cliente.bean.SectoresEconomBean;


public class ActividadesDAO extends BaseDAO{
	
	
	public ActividadesDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	//consulta de ACTIVIDADES (concatenación de BMX,INEGI,SECTOR ECONOMICO)	
	public ActividadesCompletaBean consultaActividadCompleta(String actividadBMXID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ACTIVIDADESBMXCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	actividadBMXID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ActividadesDAO.consultaActividadCompleta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		ActividadesCompletaBean actividades = new ActividadesCompletaBean();
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTIVIDADESBMXCON(" + Arrays.toString(parametros) + ")");		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ActividadesCompletaBean actividades = new ActividadesCompletaBean();
					
					actividades.setActividadBMXID(resultSet.getString(1));				
					actividades.setDescripcionBMX(resultSet.getString(2));					
					actividades.setActividadINEGIID(Utileria.completaCerosIzquierda(resultSet.getLong(3), 5));
					actividades.setDescripcionINE(resultSet.getString(4));
					actividades.setSectorEcoID(Utileria.completaCerosIzquierda(resultSet.getInt(5), 2));
					actividades.setDescripcionSEC(resultSet.getString(6));
					actividades.setClaveRiesgo(resultSet.getString(7));
					actividades.setActividadFR(resultSet.getString(8));
					actividades.setDescripcionFR(resultSet.getString(9));
					actividades.setActividadFOMUR(resultSet.getString(10));
					actividades.setDescripcionFOMUR(resultSet.getString(11));
					return actividades;
	
			}
		});
				
		return matches.size() > 0 ? (ActividadesCompletaBean) matches.get(0) : null;
	}
		
	
	//Lista de ActividadesBMX	
	public List listaActividadesPrincipal(ActividadesBMXBean actividades, int tipoLista) {
		//Query con el Store Procedure
		String query = "call ACTIVIDADESBMXLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	actividades.getDescripcion(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ActividadesDAO.listaActividadesPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};	
		//logeo de Query a ejecutar
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTIVIDADESBMXLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActividadesBMXBean actividades = new ActividadesBMXBean();			
				actividades.setActividadBMXID(resultSet.getString(1));
				actividades.setDescripcion(resultSet.getString(2));
				return actividades;				
			}
		});
				
		return matches;
	}

}
