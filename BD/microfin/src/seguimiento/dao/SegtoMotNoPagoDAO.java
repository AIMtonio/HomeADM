package seguimiento.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import seguimiento.bean.SegtoMotNoPagoBean;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class SegtoMotNoPagoDAO extends BaseDAO{

	public SegtoMotNoPagoDAO(){
		super();
	}
	
	public List listaMotivoNP(SegtoMotNoPagoBean segtoNoPago, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SEGTOMOTIVNOPAGOLIS(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
								segtoNoPago.getMotivoNPID(),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoOrigenPadoDAO.listaSegtoOrigenPago",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOMOTIVNOPAGOLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SegtoMotNoPagoBean segtoNP = new SegtoMotNoPagoBean();
				segtoNP.setMotivoNPID(resultSet.getString(1));
				segtoNP.setDescripcion(resultSet.getString(2));
				return segtoNP;
			}
		});
		return matches;
	}
	
}
