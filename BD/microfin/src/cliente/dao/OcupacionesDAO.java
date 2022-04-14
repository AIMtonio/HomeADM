package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.OcupacionesBean;

public class OcupacionesDAO extends BaseDAO{
	
	//Variables
	
	
	public OcupacionesDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
// ------------------ Transacciones ------------------------------------------
	
	//consulta de OCUPACIONES 
	public OcupacionesBean consultaOcupacion(Long ocupacionID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call OCUPACIONESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	ocupacionID,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"OcupacionesDAO.consultaOcupacion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OCUPACIONESCON(" + Arrays.toString(parametros) + ")");
		
		OcupacionesBean ocupaciones = new OcupacionesBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OcupacionesBean ocupaciones = new OcupacionesBean();
					ocupaciones.setOcupacionID(resultSet.getString(1));
					ocupaciones.setDescripcion(resultSet.getString(2));
					ocupaciones.setImplicaTrabajo(resultSet.getString(3));
					return ocupaciones;
			}
		});
		return matches.size() > 0 ? (OcupacionesBean) matches.get(0) : null;
				
	}
		
	
	//Lista de ActividadesBMX	
	public List listaOcupaciones(OcupacionesBean ocupaciones, int tipoLista) {
		//Query con el Store Procedure
		String query = "call OCUPACIONESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	ocupaciones.getDescripcion(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"OcupacionesDAO.listaOcupaciones",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OCUPACIONESLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OcupacionesBean ocupaciones = new OcupacionesBean();			
				ocupaciones.setOcupacionID(resultSet.getString(1));
				ocupaciones.setDescripcion(resultSet.getString(2));
				return ocupaciones;				
			}
		});
				
		return matches;
	}
	

}
