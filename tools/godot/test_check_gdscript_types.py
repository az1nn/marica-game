import unittest

from check_gdscript_types import validate


class GDScriptTypeGuardTests(unittest.TestCase):
    def test_accepts_typed_functions_arguments_and_inference(self):
        source = (
            'extends Node\nvar count: int = 0\n'
            'func greet(name: String) -> void:\n    var next := count + 1\n'
        )
        self.assertEqual(validate(source), [])

    def test_rejects_implicit_function_return(self):
        errors = validate('func greet(name: String):\n    pass\n')
        self.assertIn('return type', errors[0][1])

    def test_rejects_untyped_variable_and_argument(self):
        source = 'var score = 1\nfunc set_score(value) -> void:\n    pass\n'
        self.assertEqual(len(validate(source)), 2)

    def test_accepts_multiline_signature_and_generic_parameter(self):
        source = (
            'func assign(\n    mapping: Dictionary[String, int],\n'
            '    active: bool\n) -> bool:\n    return active\n'
        )
        self.assertEqual(validate(source), [])


if __name__ == '__main__':
    unittest.main()
