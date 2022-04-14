package soporte.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import soporte.bean.TiposPuestosBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
 
public class TiposPuestosDAO extends BaseDAO{
	
	public List listaTiposPuestos(TiposPuestosBean tiposPuestosBean, int tipoLista){
		List lisTipPuestos = null ;
		try{
			String query = "call TIPOSPUESTOSLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					tipoLista,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposPuestosDAO.listaTiposPuestos",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSPUESTOSLIS(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposPuestosBean tiposPuestos = new TiposPuestosBean();
					tiposPuestos.setTipoPuestoID(resultSet.getString("TipoPuestoID"));
					tiposPuestos.setDescripcion(resultSet.getString("Descripcion"));

					return tiposPuestos;
				}
			});
			lisTipPuestos =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de lista de Tipos de Puestos", e);
		}
		return lisTipPuestos;
	}
}
